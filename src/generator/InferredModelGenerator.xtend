package generator

import picker.AnnotationPicker
import entity.Annotation
import storage.AnnotationStorage

import org.eclipse.xtend.core.xtend.XtendAnnotationTarget
import org.eclipse.xtend.core.xtend.XtendClass
import org.eclipse.xtend.core.xtend.XtendFunction
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EFactory
import java.util.List
import java.util.Stack

class InferredModelGenerator
{
	new(AnnotationPicker picker, EPackage inferredMetamodel, EPackage staticMetamodel) {
		this.picker = picker
		this.metamodel = inferredMetamodel
		this.factory = inferredMetamodel.EFactoryInstance
		this.model = staticMetamodel.EFactoryInstance.create(
			findClass("BusinessContainer", staticMetamodel)
		)
	}

	def generate(AnnotationPicker picker) {
		picker.annotations.all.forEach[ visit ]
		return result
	}

	def result() {
		return model
	}

	/* Private */

	var AnnotationPicker picker
	var EObject model
	var EPackage metamodel
	var EFactory factory
	var Stack<EObject> stack = new Stack

	def private dispatch void visit(Annotation annotation) {
		val annotationName = annotation.XAnnotation.annotationType.simpleName
		val businessClass = findClass(annotationName.toFirstUpper)
		val businessObject = factory.create(businessClass)

		val target = businessClass.EAllAttributes.findFirst[ name == "target" ]
		businessObject.eSet(target, getXtendAnnotationTargetName(annotation.XTarget))

		val businessClassList = findClassList(businessClass)
		businessObjectsReference(businessClassList).add(businessObject)

		if (!stack.isEmpty) {
			val upperObject = stack.peek
			val reference = upperObject.eClass.EAllReferences.findFirst[
				name == businessClass.name.toFirstLower
			]
			(upperObject.eGet(reference) as List<EObject>).add(businessObject)
		}

		stack.push(businessObject)
		annotation.subAnnotations.all.forEach[ visit ]
		stack.pop
	}

	def private findClass(String name) {
		findClass(name, metamodel)
	}

	def private findClass(String name, EPackage metamodel) {
		return metamodel.EClassifiers.findFirst[ eObject |
			(eObject instanceof EClass) && eObject.name == name
		] as EClass
	}

	def private findClassList(EClass eClass) {
		return metamodel.EClassifiers.findFirst[ eObject |
			(eObject instanceof EClass) && eObject.name == eClass.name + "List"
		] as EClass
	}

	def private businessObjectListInstance(EClass businessClassList) {
		val objectLists = businessObjectListsReference
		var list = objectLists.findFirst[ eClass == businessClassList ]
		if (list == null) {
			list = factory.create(businessClassList)
			objectLists.add(list)
		}
		return list
	}

	def private businessObjectsReference(EClass businessClassList) {
		val businessObjectList = businessObjectListInstance(businessClassList)
		val reference = businessClassList.EAllReferences.findFirst[ true ]
		return businessObjectList.eGet(reference) as List<EObject>
	}

	def private businessObjectListsReference() {
		val reference = model.eClass.EAllReferences.findFirst[ name == "objects" ]
		return model.eGet(reference) as List<EObject>
	}

	def private getXtendAnnotationTargetName(XtendAnnotationTarget xTarget) {
		if (xTarget instanceof XtendClass) {
			return "Class:" + xTarget.name
		} else if (xTarget instanceof XtendFunction) {
			return "Function:" + xTarget.name
		} else {
			return "?"
		}
	}
}
