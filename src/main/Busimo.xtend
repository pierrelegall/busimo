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

	def static void make() {
		val picker = new AnnotationPicker
		val inputPath = Paths.get("./assets/inputs/EcoreTest.xtend")
		picker.pick(Utils::loadXtendFile(inputPath.toRealPath.toString))

		val staticMetamodelGenerator = new MetametamodelGenerator
		val staticMetamodel = staticMetamodelGenerator.generate
		val staticMetamodelPath = Paths.get("./assets/gen/static_metamodel.ecore")
		Utils::createFileIfNotExists(staticMetamodelPath.toString)
		Utils::saveModel(staticMetamodel, staticMetamodelPath.toRealPath.toString, "ecore")

		val inferredMetamodelGenerator = new MetamodelGenerator
		val inferredMetamodel = inferredMetamodelGenerator.generate(picker, staticMetamodel)
		val inferredMetamodelPath = Paths.get("./assets/gen/inferred_metamodel.ecore")
		Utils::createFileIfNotExists(inferredMetamodelPath.toString)
		Utils::saveModel(inferredMetamodel, inferredMetamodelPath.toRealPath.toString, "ecore")

		val modelGenerator = new ModelGenerator(picker, inferredMetamodel, staticMetamodel)
		val model = modelGenerator.generate(picker)
		val modelPath = Paths.get("./assets/gen/inferred_model.xmi")
		Utils::createFileIfNotExists(modelPath.toString)
		Utils::saveModelToXmi(model, modelPath.toRealPath.toString, "*")

		val designGenerator = new DesignGenerator
		val design = designGenerator.generate(inferredMetamodel)
		val designPath = Paths.get("./assets/gen/style.odesign")
		Utils::createFileIfNotExists(designPath.toString)
		Utils::saveModel(design, designPath.toRealPath.toString)

		val representationGenerator = new RepresentationGenerator
		val representation = representationGenerator.generate
		val representationPath = Paths.get("./assets/gen/representation.aird")
		Utils::createFileIfNotExists(representationPath.toString)
		Utils::saveModel(representation, representationPath.toRealPath.toString)
	}
}
