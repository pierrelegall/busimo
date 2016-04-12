package picker

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.core.xtend.XtendFile
import org.eclipse.xtend.core.xtend.XtendFunction
import org.eclipse.xtend.core.xtend.XtendClass
import org.eclipse.xtend.core.xtend.XtendMember
import java.util.HashMap
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import java.util.Map

class AnnotationPicker
{
	def pick(XtendFile file) {
		source = file
		source.visit
	}

	def annotations() {
		return annotationsWithReferences.keySet
	}

	def annotatedElements() {
		annotationsWithReferences.values
	}

	def annotationTarget(XAnnotation annotation) {
		return annotationsWithReferences.get(annotation)
	}

	/* Private */

	var XtendFile source
	@Accessors var Map<XAnnotation, XtendMember> annotationsWithReferences = new HashMap<XAnnotation, XtendMember>

	def private dispatch void visit(XtendFile ast) {
		ast.xtendTypes.forEach[ visit ]
	}

	def private dispatch void visit(XtendMember member) {}

	def private dispatch void visit(XtendClass klass) {
		klass.members.forEach[ visit ]
	}

	def private dispatch void visit(XtendFunction function) {
		function.annotations.forEach[ annotation |
			annotationsWithReferences.put(annotation, function)
		]
	}
}
