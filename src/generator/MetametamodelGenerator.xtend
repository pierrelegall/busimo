package generator

import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage

class MetametamodelGenerator
{
	def generate() {
		initializeMetamodel
		return metametamodel
	}

	def EPackage result() {
		return metametamodel
	}

	/* Private */

	var EPackage metametamodel
	var EClass businessObject
	var EClass businessObjectList
	var EClass businessContainer

	def private void initializeMetamodel() {
		metametamodel = EcoreFactory.eINSTANCE.createEPackage()
		metametamodel.name = "BusimoModel"
		metametamodel.nsPrefix = "busimo.model"
		metametamodel.nsURI = "busimo.model"
		initializeBusinessObject
		metametamodel.EClassifiers.add(businessObject)
		initializeBusinessObjectList
		metametamodel.EClassifiers.add(businessObjectList)
		initializeBusinessContainer
		metametamodel.EClassifiers.add(businessContainer)
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
	}
}
