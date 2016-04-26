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

	private
	def void initializeMetamodel() {
		metamodel = EcoreFactory.eINSTANCE.createEPackage
		metamodel.name = "BusimoInferredModel"
		metamodel.nsPrefix = "busimo.model.inferred"
		metamodel.nsURI = "busimo.model.inferred"
	}

	/**
	 * @TODO: use the full JVM annotation name
	 */
	private
	def dispatch void visit(Annotation annotation) {
		val annotationName = annotation.XAnnotation.annotationType.simpleName
		val eClass = createClassIfNotExists(annotationName)

		val eClassList = createClassList(eClass)
		if (!metamodel.EClassifiers.exists[ name == eClassList.name ]) {
			metamodel.EClassifiers.add(eClassList)
		}

		if (!stack.isEmpty) {
			val upperAnnotation = stack.peek
			if (!upperAnnotation.EStructuralFeatures.exists[ EType == eClass ]) {
				upperAnnotation.EStructuralFeatures.add(createReference(eClass))
			}
		}

		stack.push(eClass)
		annotation.subAnnotations.all.forEach[ visit ]
		stack.pop
	}

	private
	def createClassIfNotExists(String className) {
		var eClass = findClass(className)
		if (eClass == null) {
			return createClass(className)
		} else {
			return eClass
		}
	}

	private
	def classExists(String annotationName) {
		return metamodel.EClassifiers.filter[ eObject |
			eObject instanceof EClass
		].exists[ eObject |
			(eObject as EClass).name == annotationName
		]
	}

	private
	def createClass(String name) {
		val eClass = EcoreFactory.eINSTANCE.createEClass
		eClass.name = name.toFirstUpper
		metamodel.EClassifiers.add(eClass)
		eClass.ESuperTypes.add(findClass("BObject", staticMetamodel))
		return eClass
	}

	private
	def createReference(EClass eClass, boolean containment) {
		val reference = EcoreFactory.eINSTANCE.createEReference
		reference.name = eClass.name.toFirstLower
		reference.EType = eClass
		reference.lowerBound = 0
		reference.upperBound = -1
		reference.containment = containment
		return reference
	}

	private
	def createReference(EClass eClass) {
		return createReference(eClass, false)
	}

	private
	def createClassList(EClass eClass) {
		val eClassList = EcoreFactory.eINSTANCE.createEClass
		eClassList.name = eClass.name.toFirstUpper + "List"
		eClassList.EStructuralFeatures.add(createReference(eClass, true))
		eClassList.ESuperTypes.add(findClass("BObjectList", staticMetamodel))
		return eClassList
	}

	private
	def findClass(String name, EPackage metamodel) {
		return metamodel.EClassifiers.findFirst[ eObject |
			(eObject instanceof EClass) && eObject.name == name
		] as EClass
	}

	private
	def findClass(String name) {
		return findClass(name, metamodel)
	}
}
