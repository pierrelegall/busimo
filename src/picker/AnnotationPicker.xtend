package picker

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.core.xtend.XtendFile
import org.eclipse.xtend.core.xtend.XtendFunction
import org.eclipse.xtend.core.xtend.XtendClass
import org.eclipse.xtend.core.xtend.XtendMember
import java.util.Stack

import storage.AnnotationStorage

class AnnotationPicker
{
	new() {
		stack.push(new AnnotationStorage)
	}

	def pick(XtendFile file) {
		source = file
		source.visit
	}

	def annotations() {
		return stack.peek
	}

	/* Private */

	var XtendFile source
	val stack = new Stack<AnnotationStorage>

	def private dispatch void visit(XtendFile ast) {
		ast.xtendTypes.forEach[ visit ]
	}

	def private dispatch void visit(XtendMember member) {}

	def private dispatch void visit(XtendClass klass) {
		stack.push(new AnnotationStorage)
		klass.members.forEach[ visit ]
		val subAnnotations = stack.pop
		stack.peek.add(klass, subAnnotations)
	}

	def private dispatch void visit(XtendFunction function) {
		stack.peek.add(function)
	}
}
