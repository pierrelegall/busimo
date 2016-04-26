package generator

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EClass

class DesignGenerator
{
	def generate(EPackage metamodel) {
		design = metamodel.visit
		return result
	}

	def result() {
		return design
	}

	/* Private */

	var String design

	private
	def dispatch visit(EPackage backage) {
		val classes = backage.eContents.filter[ eObject |
				eObject instanceof EClass
		]
		return '''
			<?xml version="1.0" encoding="UTF-8"?>
			<description:Group xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:description="http://www.eclipse.org/sirius/description/1.1.0" xmlns:description_1="http://www.eclipse.org/sirius/diagram/description/1.1.0" xmlns:style="http://www.eclipse.org/sirius/diagram/description/style/1.1.0" name="genericdesign" version="10.1.0.201507271600">
			  <ownedViewpoints name="default" modelFileExtension="xmi">
			    <ownedRepresentations xsi:type="This diagram have an auto generated design" name="diagram" label="Default diagram" domainClass="«backage.nsURI /* TODO */ + ".TestList"»" enablePopupBars="true">
			    <defaultLayer name="Default">
			      «FOR klass : classes»
			      	«klass.visit»
			      «ENDFOR»
			    </defaultLayer>
			    </ownedRepresentations>
			  </ownedViewpoints>
			</description:Group>
		'''
	}

	private
	def dispatch visit(EObject object) {}

	private
	def dispatch visit(EClass klass) {
		return '''
			<nodeMappings name="«klass.name»" label="«klass.name»" semanticCandidatesExpression="feature:members" domainClass="«klass.name»">
			  <style xsi:type="style:SquareDescription" labelPosition="node" resizeKind="NSEW">
			    <borderColor xsi:type="description:SystemColor" href="environment:/viewpoint#//@systemColors/@entries[name='black']"/>
			    <labelColor xsi:type="description:SystemColor" href="environment:/viewpoint#//@systemColors/@entries[name='black']"/>
			    <color xsi:type="description:SystemColor" href="environment:/viewpoint#//@systemColors/@entries[name='gray']"/>
			  </style>
			</nodeMappings>
		'''
	}
}
