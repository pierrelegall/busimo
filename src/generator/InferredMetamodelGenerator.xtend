package generator

import picker.AnnotationPicker
import entity.Annotation

import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EcoreFactory

class InferredMetamodelGenerator
{
	def generate(AnnotationPicker picker, EPackage metametamodel) {
		this.metametamodel = metametamodel
		initializeMetamodel
		picker.annotations.all.forEach[ visit ]
		return result
	}

	def EPackage result() {
		return metamodel
	}

	/* Private */

	var EPackage metametamodel
	var EPackage metamodel

	def private void initializeMetamodel() {
		metamodel = EcoreFactory.eINSTANCE.createEPackage()
		metamodel.name = "BusimoInferredModel"
		metamodel.nsPrefix = "busimo.inferred.model"
		metamodel.nsURI = "busimo.inferred.model"
	}

	/**
	 * @TODO: use the full JVM annotation name
	 */
	def private dispatch void visit(Annotation annotation) {
		val annotationName = annotation.XAnnotation.annotationType.simpleName
		if (!classExists(annotationName)) {
			val eClass = createClass(annotationName)
			metamodel.EClassifiers.add(eClass)
			val eClassList = createClassList(eClass)
			metamodel.EClassifiers.add(eClassList)
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
		eClass.ESuperTypes.add(findClass("BusinessObject"))
		return eClass
	}

	def private createClassList(EClass eClass) {
		val eClassList = EcoreFactory.eINSTANCE.createEClass
		eClassList.name = eClass.name.toFirstUpper + "List"
		eClassList.ESuperTypes.add(findClass("BusinessObjectList"))
		return eClassList
	}

	def private findClass(String name) {
		return metametamodel.EClassifiers.findFirst[ eObject |
			(eObject instanceof EClass) && eObject.name == name
		] as EClass
	}
}
