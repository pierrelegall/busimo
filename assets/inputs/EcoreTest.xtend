package test

import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.InMemoryFileSystemAccess
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.Ignore
import org.junit.runner.RunWith

import static org.junit.Assert.*

class EcoreTest
{
  @Test
  def void testStructure() {
    assertNotNull(root)
    assertEquals(root.name, "ecoretest")
    assertNull(root.imports)

    assertEquals(ecore.name,           "Ecore")
    assertEquals(ecoreMt.name,         "EcoreMT")
    assertEquals(testClassifiers.name, "testListClassifiersCount")
    assertEquals(loadEcore.name,       "loadEcore")
    assertEquals(test.name,            "test")
  }

  @Test
  def void testRelations() {
    assertEquals(ecoreMt.extracted, ecore)
    assertEquals(ecore.exactType, ecoreMt)
  }

  @Test
  def void testImplements() {
    assertEquals(ecore.^implements.size, 1)
    assertTrue(ecore.^implements.contains(ecoreMt))
  }

  @Test
  def void testInheritance() {
    assertEquals(ecore.superLanguages.size, 0)
  }

  @Test
  @Ignore
  def void testSubtyping() {
    assertEquals(ecoreMt.subtypingRelations.size, 0)
  }

  @Test
  def void testGeneration() {
    val fsa = new InMemoryFileSystemAccess
    generator.doGenerate(root.eResource, fsa)

    assertEquals(fsa.textFiles.size, 46)
  }

	@Ignore
  @Test
  def void testRuntime() {}
}
