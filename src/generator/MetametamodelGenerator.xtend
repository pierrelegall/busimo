package generator

import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage

class MetametamodelGenerator
{
	def generate() {
		initializeMetamodel
		return result
	}

	def EPackage result() {
		return metamodel
	}

	/* Private */

	var EPackage metamodel
	var EClass businessObject
	var EClass businessObjectList
	var EClass businessContainer

	def private void initializeMetamodel() {
		metamodel = EcoreFactory.eINSTANCE.createEPackage()
		metamodel.name = "BusimoModel"
		metamodel.nsPrefix = "busimo.model"
		metamodel.nsURI = "busimo.model"
		initializeBusinessObject
		metamodel.EClassifiers.add(businessObject)
		initializeBusinessObjectList
		metamodel.EClassifiers.add(businessObjectList)
		initializeBusinessContainer
		metamodel.EClassifiers.add(businessContainer)
	}

	def private void initializeBusinessObject() {
		businessObject = EcoreFactory.eINSTANCE.createEClass
		businessObject.name = "BusinessObject"
		val attribute = EcoreFactory.eINSTANCE.createEAttribute
		attribute.name = "xtendMember"
		attribute.EType = EcorePackage.eINSTANCE.getEString
		businessObject.EStructuralFeatures.add(attribute)
	}

	def private void initializeBusinessObjectList() {
		businessObjectList = EcoreFactory.eINSTANCE.createEClass
		businessObjectList.name = "BusinessObjectList"
		val reference = EcoreFactory.eINSTANCE.createEReference
		reference.name = "objects"
		reference.EType = businessObject
		reference.lowerBound = 0
		reference.upperBound = -1
		reference.containment = true
		businessObjectList.EStructuralFeatures.add(reference)
	}

	def private void initializeBusinessContainer() {
		businessContainer = EcoreFactory.eINSTANCE.createEClass
		businessContainer.name = "BusinessContainer"
		val reference = EcoreFactory.eINSTANCE.createEReference
		reference.name = "objectLists"
		reference.EType = businessObjectList
		reference.lowerBound = 0
		reference.upperBound = -1
		reference.containment = true
		businessContainer.EStructuralFeatures.add(reference)
		metamodel.EClassifiers.add(businessContainer)
	}
}
