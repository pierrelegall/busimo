package generator

import picker.AnnotationPicker
import entity.AnnotatedNode
import entity.Annotation

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EFactory
import org.eclipse.xtend.core.xtend.XtendAnnotationTarget
import org.eclipse.xtend.core.xtend.XtendClass
import org.eclipse.xtend.core.xtend.XtendFunction
import org.eclipse.xtend.core.xtend.XtendField
import java.util.List
import java.util.ArrayList
import java.util.Stack

/**
 * Infer the model from the annotation picker
 */
class InferredModelGenerator
{
	/**
	 * The constructor
	 */
	new(AnnotationPicker picker, EPackage inferredMetamodel, EPackage staticMetamodel) {
		this.picker = picker
		this.metamodel = inferredMetamodel
		this.factory = inferredMetamodel.EFactoryInstance
		this.model = staticMetamodel.EFactoryInstance.create(
			findClass("BContainer", staticMetamodel)
		)
	}

	/**
	 * Generate the model and return it
	 */
	def generate(AnnotationPicker picker) {
		picker.rootNodes.forEach[ visit ]
		return result
	}

	/**
	 * Get the resulting model
	 */
	def result() {
		return model
	}

	/* Private */

	var AnnotationPicker picker
	var EObject model
	var EPackage metamodel
	var EFactory factory
	var Stack<AnnotatedNode> nodeStack = new Stack
	var Stack<ArrayList<EObject>> objectsStack = new Stack
	var Stack<ArrayList<EObject>> referencesStack = new Stack

	private
	def dispatch void visit(AnnotatedNode node) {
		nodeStack.push(node)
		objectsStack.push(new ArrayList<EObject>)
		referencesStack.push(new ArrayList<EObject>)

		node.annotations.forEach[ visit ]
		node.children.forEach[ visit ]

		objectsStack.pop
		if (!objectsStack.isEmpty) {
			objectsStack.peek.forEach[ object |
				referencesStack.peek.forEach[ referencedObject |
					val reference = object.eClass.EAllReferences.findFirst[
						name == referencedObject.eClass.name.toFirstLower
					]
					(object.eGet(reference) as List<EObject>).add(referencedObject)
				]
			]
		}
		referencesStack.pop
		nodeStack.pop
	}

	private
	def dispatch void visit(Annotation annotation) {
		val annotationName = annotation.type.simpleName
		val businessClass = findClass(annotationName.toFirstUpper)
		val businessObject = factory.create(businessClass)

		val target = businessClass.EAllAttributes.findFirst[ name == "target" ]
		businessObject.eSet(target, getXtendAnnotationTargetName(nodeStack.peek.sourceNode))
		objectsStack.peek.add(businessObject)
		referencesStack.peek.add(businessObject)

		val businessClassList = findClassList(businessClass)
		businessObjectsReference(businessClassList).add(businessObject)
	}

	private
	def findClass(String name) {
		findClass(name, metamodel)
	}

	private
	def findClass(String name, EPackage metamodel) {
		return metamodel.EClassifiers.findFirst[ eObject |
			(eObject instanceof EClass) && eObject.name == name
		] as EClass
	}

	private
	def findClassList(EClass eClass) {
		return metamodel.EClassifiers.findFirst[ eObject |
			(eObject instanceof EClass) && eObject.name == eClass.name + "List"
		] as EClass
	}

	private
	def businessObjectListInstance(EClass businessClassList) {
		val objectLists = businessObjectListsReference
		var list = objectLists.findFirst[ eClass == businessClassList ]
		if (list == null) {
			list = factory.create(businessClassList)
			objectLists.add(list)
		}
		return list
	}

	private
	def businessObjectsReference(EClass businessClassList) {
		val businessObjectList = businessObjectListInstance(businessClassList)
		val reference = businessClassList.EAllReferences.findFirst[ true ]
		return businessObjectList.eGet(reference) as List<EObject>
	}

	private
	def businessObjectListsReference() {
		val reference = model.eClass.EAllReferences.findFirst[ name == "objects" ]
		return model.eGet(reference) as List<EObject>
	}

	private
	def getXtendAnnotationTargetName(XtendAnnotationTarget xTarget) {
		if (xTarget instanceof XtendClass) {
			return "Class:" + xTarget.name
		} else if (xTarget instanceof XtendFunction) {
			return "Function:" + xTarget.name
		} else if (xTarget instanceof XtendField) {
			return "Field:" + xTarget.name
		} else {
			return "?"
		}
	}
}
