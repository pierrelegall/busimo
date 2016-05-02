package picker

import entity.AnnotatedNode

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.core.xtend.XtendFile
import org.eclipse.xtend.core.xtend.XtendMember
import org.eclipse.xtend.core.xtend.XtendClass
import org.eclipse.xtend.core.xtend.XtendField
import org.eclipse.xtend.core.xtend.XtendFunction
import java.util.List
import java.util.ArrayList
import java.util.Stack

/**
 * The annotation picker build an annotation storage
 * according to the XtendFile input.
 */
class AnnotationPicker
{
	/**
	 * Pick the annotation in the XtendFile
	 */
	def pick(XtendFile codeAst) {
		codeAst.visit
	}

	/* Private */

	@Accessors val List<AnnotatedNode> rootNodes = new ArrayList<AnnotatedNode>
	val stack = new Stack<AnnotatedNode>

	private
	def dispatch void visit(XtendFile ast) {
		ast.xtendTypes.forEach[ visit ]
	}

	private
	def dispatch void visit(XtendMember member) {}

	private
	def dispatch void visit(XtendClass klass) {
		if (klass.annotations.isEmpty) {
			klass.members.forEach[ visit ]
		} else {
			stack.push(new AnnotatedNode(klass))
			klass.members.forEach[ visit ]
			val node = stack.pop
			if (stack.isEmpty) rootNodes.add(node)
			else stack.peek.children.add(node)
		}
	}

	private
	def dispatch void visit(XtendField field) {
		if (!field.isExtension) stack.peek.children.add(new AnnotatedNode(field))
	}

	private
	def dispatch void visit(XtendFunction function) {
		if (!function.isStatic) stack.peek.children.add(new AnnotatedNode(function))
	}
}
