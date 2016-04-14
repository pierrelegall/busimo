package util

import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.XMLResource
import org.eclipse.emf.ecore.xmi.impl.XMLResourceFactoryImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.emf.common.util.URI
import org.eclipse.xtend.core.xtend.XtendFile
import org.eclipse.xtend.core.XtendStandaloneSetup
import java.nio.file.Paths
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.io.IOException
import java.io.File
import java.io.FileWriter
import java.io.BufferedWriter
import java.util.Map
import java.util.HashMap

class Utils
{
	def static void saveModel(EObject model, String uri, String type) {
		val resourceSet = new ResourceSetImpl();

		resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put(type, new XMLResourceFactoryImpl)
		val resource = resourceSet.createResource(URI.createURI(uri))
		resource.getContents().add(model)

		try {
			val options = new HashMap
			options.put(XMLResource.OPTION_SCHEMA_LOCATION, true)
			resource.save(options)
		} catch (IOException exception) {
			exception.printStackTrace
		}
	}

	def static void saveModel(String content, String uri) {
		val file = new File(uri);
		if (!file.exists) file.createNewFile

		try {
			val fileWriter = new FileWriter(file.getAbsoluteFile())
			val bufferWriter = new BufferedWriter(fileWriter)
			bufferWriter.write(content)
			bufferWriter.close
		} catch (IOException exception) {
			exception.printStackTrace
		}
	}

	def static void saveModelToXmi(EObject model, String uri, String type) {
		val registry = Resource.Factory.Registry.INSTANCE
		val Map<String, Object> map = registry.getExtensionToFactoryMap
		map.put("uri", new XMIResourceFactoryImpl)
		val resourceSet = new ResourceSetImpl

		val resource = resourceSet.createResource(URI.createURI(uri))
		resource.getContents().add(model)

		try {
			val options = new HashMap
			options.put(XMLResource.OPTION_SCHEMA_LOCATION, true)
			resource.save(options)
		} catch (IOException exception) {
			exception.printStackTrace
		}
	}

	def static XtendFile loadXtendFile(String uri) {
		XtendStandaloneSetup::doSetup
		val resourceSet = new ResourceSetImpl
		val resource = resourceSet.getResource(URI::createFileURI(uri), true)
		val ast = resource.contents.head
		return ast as XtendFile
	}

	def static XtendFile loadXtendFile(File file) {
		loadXtendFile(file.absolutePath)
	}

	/* Private */

	// UGLY HACK, not used anymore but maybe useful
	def private static cleanPath(String uri) {
		val path = Paths.get(uri)
		val charset = StandardCharsets.UTF_8
		var content = new String(Files.readAllBytes(path), charset)
		content = content.replaceAll("./assets/gen/", "./")
		Files.write(path, content.getBytes(charset))
	}
}
