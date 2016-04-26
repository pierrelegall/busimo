package generator

import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EcoreFactory
import java.util.Stack

import picker.AnnotationPicker
import entity.Annotation
import storage.AnnotationStorage


class InferredMetamodelGenerator
{
	def generate(AnnotationPicker picker, EPackage staticMetamodel) {
		this.staticMetamodel = staticMetamodel
		initializeMetamodel
		picker.annotations.all.forEach[ visit ]
		return result
	}

	def result() {
		return metamodel
	}

	/* Private */

	var EPackage staticMetamodel
	var EPackage metamodel
	var Stack<EClass> stack = new Stack

	def private void initializeMetamodel() {
		metamodel = EcoreFactory.eINSTANCE.createEPackage
		metamodel.name = "BusimoInferredModel"
		metamodel.nsPrefix = "busimo.model.inferred"
		metamodel.nsURI = "busimo.model.inferred"
	}

	/**
	 * @TODO: use the full JVM annotation name
	 */
	def private dispatch void visit(Annotation annotation) {
		val annotationName = annotation.XAnnotation.annotationType.simpleName
		val eClass = createClassIfNotExists(annotationName)
		if (stack.isEmpty) {
			val eClassList = createClassList(eClass)
			if (!metamodel.EClassifiers.exists[ name == eClassList.name ]) {
				metamodel.EClassifiers.add(eClassList)
			}
		} else {
			val upperAnnotation = stack.peek
			if (!upperAnnotation.EStructuralFeatures.exists[ EType == eClass ]) {
				upperAnnotation.EStructuralFeatures.add(createReference(eClass))
			}
		}
		stack.push(eClass)
		annotation.subAnnotations.visit
	}

	def private dispatch void visit(AnnotationStorage subAnnotations) {
		subAnnotations.all.forEach[ visit ]
		stack.pop
	}

	def private createClassIfNotExists(String className) {
		var eClass = findClass(className)
		if (eClass == null) {
			return createClass(className)
		} else {
			return eClass
		}
	}

	def private classExists(String annotationName) {
		return metamodel.EClassifiers.filter[ eObject |
			eObject instanceof EClass
		].exists[ eObject |
			(eObject as EClass).name == annotationName
		]
	}

	def private createClass(String name) {
		val eClass = EcoreFactory.eINSTANCE.createEClass
		eClass.name = name.toFirstUpper
		metamodel.EClassifiers.add(eClass)
		eClass.ESuperTypes.add(findClass("BusinessObject", staticMetamodel))
		return eClass
	}

	def private createReference(EClass eClass) {
		val reference = EcoreFactory.eINSTANCE.createEReference
		reference.name = eClass.name.toFirstLower
		reference.EType = eClass
		reference.lowerBound = 0
		reference.upperBound = -1
		reference.containment = true
		return reference
	}

	def private createClassList(EClass eClass) {
		val eClassList = EcoreFactory.eINSTANCE.createEClass
		eClassList.name = eClass.name.toFirstUpper + "List"
		eClassList.EStructuralFeatures.add(createReference(eClass))
		eClassList.ESuperTypes.add(findClass("BusinessObjectList", staticMetamodel))
		return eClassList
	}

	def private findClass(String name, EPackage metamodel) {
		return metamodel.EClassifiers.findFirst[ eObject |
			(eObject instanceof EClass) && eObject.name == name
		] as EClass
	}

	def private findClass(String name) {
		return findClass(name, metamodel)
	}
}
