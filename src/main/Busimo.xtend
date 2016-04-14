package main

import generator.MetametamodelGenerator
import generator.MetamodelGenerator
import generator.ModelGenerator
import generator.DesignGenerator
import generator.RepresentationGenerator
import picker.AnnotationPicker
import util.Utils

import java.nio.file.Paths

class Busimo
{
	def static void main(String[] args) {
		make
		println("Busimo tasks finished.")
	}

	def static make() {
		val picker = new AnnotationPicker
		val inputPath = Paths.get("./assets/inputs/EcoreTest.xtend")
		picker.pick(Utils::loadXtendFile(inputPath.toRealPath.toString))

		val metametamodelGenerator = new MetametamodelGenerator
		val metametamodel = metametamodelGenerator.generate
		val metametamodelPath = Paths.get("./assets/gen/metametamodel.ecore")
		Utils::saveModel(metametamodel, metametamodelPath.toRealPath.toString, "ecore")

		val metamodelGenerator = new MetamodelGenerator
		val metamodel = metamodelGenerator.generate(picker, metametamodel)
		val metamodelPath = Paths.get("./assets/gen/metamodel.ecore")
		Utils::saveModel(metamodel, metamodelPath.toRealPath.toString, "ecore")

		val modelGenerator = new ModelGenerator(picker, metamodel)
		val model = modelGenerator.generate(picker)
		val modelPath = Paths.get("./assets/gen/model.xmi")
		Utils::saveModelToXmi(model, modelPath.toRealPath.toString, "*")

		val designGenerator = new DesignGenerator
		val design = designGenerator.generate(metamodel)
		val designPath = Paths.get("./assets/gen/style.odesign")
		Utils::saveModel(design, designPath.toRealPath.toString)

		val representationGenerator = new RepresentationGenerator
		val representation = representationGenerator.generate
		val representationPath = Paths.get("./assets/gen/representation.aird")
		Utils::saveModel(representation, representationPath.toRealPath.toString)
	}
}
