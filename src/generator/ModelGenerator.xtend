package generator

import picker.AnnotationPicker

import org.eclipse.xtend.core.xtend.XtendFunction
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EFactory
import java.util.List
import entity.Annotation

class ModelGenerator
{
	new(AnnotationPicker picker, EPackage metamodel) {
		this.picker = picker
		this.metamodel = metamodel
		this.factory = metamodel.EFactoryInstance
	}

	def generate(AnnotationPicker picker) {
		picker.annotations.all.forEach[ visit ]
	}

	def result() {
		model
	}

	/* Private */

	var EObject model
	var AnnotationPicker picker
	var EPackage metamodel
	var EFactory factory

	def private dispatch void visit(Annotation annotation) {
		val annotationName = annotation.XAnnotation.annotationType.simpleName
		val eClass = findEClassByName(annotationName)
		val xtendMember = eClass.EAttributes.findFirst[ name == "xtendMember" ]
		val method = (annotation.XTarget as XtendFunction).name
		val eObject = factory.create(eClass)
		eObject.eSet(xtendMember, method)

		val eListClass = findEClassByName(annotationName + "List")
		if (model == null) model = factory.create(eListClass)
		val eReference = eListClass.EReferences.findFirst[
			name == eClass.name.toFirstLower + "List"
		] as EReference

		(model.eGet(eReference) as List).add(eObject)
	}

	def private findEClassByName(String name) {
		return metamodel.eContents.findFirst[ eObject |
			eObject instanceof EClass && (eObject as EClass).name == name
		] as EClass
	}
}
