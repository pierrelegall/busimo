package java.test.util

import static org.junit.Assert.*
import org.junit.Test
import org.junit.Ignore

class StringTest
{
  var String string

  def setup() {
    string = new String
  }

  @Test
  def void testToString() {
    assertEquals(string, string.toString)
  }

  @Test
  def void testToString2() {
    assertEquals(string, string.toString)
  }
}
