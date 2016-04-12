package generator

class RepresentationGenerator
{
	def generate() {
		representation = '''
			<?xml version="1.0" encoding="UTF-8"?>
			<viewpoint:DAnalysis xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:description="http://www.eclipse.org/sirius/description/1.1.0" xmlns:viewpoint="http://www.eclipse.org/sirius/1.1.0" xsi:schemaLocation="http://www.eclipse.org/sirius/description/1.1.0 http://www.eclipse.org/sirius/1.1.0#//description" xmi:id="_BOQnUP1qEeWvBbmp3DelTQ" selectedViews="_BotusP1qEeWvBbmp3DelTQ" version="10.1.0.201509162000">
			  <semanticResources>model.xmi</semanticResources>
			    <ownedViews xmi:type="viewpoint:DRepresentationContainer" xmi:id="_BotusP1qEeWvBbmp3DelTQ">
			    <viewpoint xmi:type="description:Viewpoint" href="style-mano.odesign#//@ownedViewpoints[name='default']"/>
			  </ownedViews>
			</viewpoint:DAnalysis>
		'''
	}

	def result() {
		representation
	}

	/* Private */

	var String representation
}
