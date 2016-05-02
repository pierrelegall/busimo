package generator

import picker.AnnotationPicker
import entity.Annotation
import entity.AnnotatedNode

import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EcoreFactory
import java.util.Stack
import java.util.ArrayList

/**
 * Infer the metamodel from the annotation picker
 */
class InferredMetamodelGenerator
{
	/**
	 * Generate the metamodel and return it
	 */
	def generate(AnnotationPicker picker, EPackage staticMetamodel) {
		this.staticMetamodel = staticMetamodel
		initializeMetamodel
		picker.rootNodes.forEach[ visit ]
		return result
	}

	/**
	 * Get the resulting metamodel
	 */
	def result() {
		return metamodel
	}

	/* Private */

	var EPackage staticMetamodel
	var EPackage metamodel
	var eClassStack = new Stack<ArrayList<EClass>>
	var referencesStack = new Stack<ArrayList<EReference>>

	private
	def void initializeMetamodel() {
		metamodel = EcoreFactory.eINSTANCE.createEPackage
		metamodel.name = "BusimoInferredModel"
		metamodel.nsPrefix = "busimo.model.inferred"
		metamodel.nsURI = "busimo.model.inferred"
	}

	private
	def dispatch void visit(AnnotatedNode node) {
		eClassStack.push(new ArrayList<EClass>)
		referencesStack.push(new ArrayList<EReference>)

		node.annotations.forEach[ visit ]
		node.children.forEach[ visit ]

		eClassStack.pop
		if (!eClassStack.isEmpty) {
			eClassStack.peek.forEach[ eClass |
				referencesStack.peek.forEach[ reference |
					if (!eClass.EStructuralFeatures.exists[ name == reference.name ]) {
						eClass.EStructuralFeatures.add(reference)
					}
				]
			]
		}
		referencesStack.pop
	}

	/**
	 * @TODO: use the full JVM annotation name
	 */
	private
	def dispatch void visit(Annotation annotation) {
		val annotationName = annotation.type.simpleName
		val eClass = createClassIfNotExists(annotationName)
		eClassStack.peek.add(eClass)
		createClassListIfNotExists(eClass)
		referencesStack.peek.add(createReference(eClass))
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
	def createClassListIfNotExists(EClass eClass) {
		val eClassList = findClass(eClass.name.toFirstUpper + "List")
		if (eClassList == null) {
			return createClassList(eClass)
		} else {
			return eClassList
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
		eClass.ESuperTypes.add(findClass("BObject", staticMetamodel))
		metamodel.EClassifiers.add(eClass)
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
		metamodel.EClassifiers.add(eClassList)
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
