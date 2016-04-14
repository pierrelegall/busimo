package generator

import picker.AnnotationPicker
import entity.Annotation

import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage

class MetamodelGenerator
{
	def generate(AnnotationPicker picker) {
		initializeMetamodel
		picker.annotations.all.forEach[ visit ]
		return result
	}

	def EPackage result() {
		return metamodel
	}

	/* Private */

	var EPackage metamodel

	def private initializeMetamodel() {
		metamodel = EcoreFactory.eINSTANCE.createEPackage()
		metamodel.name = "BusimoInferredDomain"
		metamodel.nsPrefix = "busimo.inferred.domain"
		metamodel.nsURI = "busimo.inferred.domain"
	}

	/**
	 * @TODO: use the full annotation JVM name
	 */
	def private dispatch void visit(Annotation annotation) {
		val annotationName = annotation.XAnnotation.annotationType.simpleName
		if (!classExists(annotationName)) {
			val eClass = createClass(annotationName)
			val eClassList = createListClass(eClass)
			metamodel.EClassifiers.add(eClass)
			metamodel.EClassifiers.add(eClassList)
		}
	}

	def private classExists(String annotationName) {
		val classes = metamodel.eContents.filter[ eObject | eObject instanceof EClass ]
		return classes.exists[eObject|(eObject as EClass).name == annotationName]
	}

	def private createClass(String name) {
		val eClass = EcoreFactory.eINSTANCE.createEClass
		eClass.name = name.toFirstUpper
		val attribute = EcoreFactory.eINSTANCE.createEAttribute
		attribute.name = "xtendMember"
		attribute.EType = EcorePackage.eINSTANCE.getEString
		eClass.EStructuralFeatures.add(attribute)
		return eClass
	}

	def private createListClass(EClass eClass) {
		val eClassList = EcoreFactory.eINSTANCE.createEClass
		eClassList.name = eClass.name.toFirstUpper + "List"
		val reference = EcoreFactory.eINSTANCE.createEReference
		reference.name = eClass.name.toFirstLower + "List"
		reference.EType = eClass
		reference.lowerBound = 0
		reference.upperBound = -1
		reference.containment = true
		eClassList.EStructuralFeatures.add(reference)
		return eClassList
	}
}
