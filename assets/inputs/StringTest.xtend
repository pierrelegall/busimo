package java.test.util

import static org.junit.Assert.*
import org.junit.Test
import org.junit.Ignore

class StringTest
{
  @Test
  def void testToString() {
  	string = ""
    assertEquals(string, string.toString)
    string = "test"
    assertEquals(string, string.toString)
  }

  @Test
  def void testLength() {
    assertEquals(new String("").length, 0)
    assertEquals(new String("test").length, 4)
  }
}
