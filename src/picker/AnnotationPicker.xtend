package picker

import storage.AnnotationStorage

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.core.xtend.XtendFile
import org.eclipse.xtend.core.xtend.XtendFunction
import org.eclipse.xtend.core.xtend.XtendClass
import org.eclipse.xtend.core.xtend.XtendMember

class AnnotationPicker
{
	def pick(XtendFile file) {
		source = file
		source.visit
	}

	def annotations() {
		return storage
	}

	/* Private */

	var XtendFile source
	@Accessors val storage = new AnnotationStorage

	def private dispatch void visit(XtendFile ast) {
		ast.xtendTypes.forEach[ visit ]
	}

	def private dispatch void visit(XtendMember member) {}

	def private dispatch void visit(XtendClass klass) {
		klass.members.forEach[ visit ]
	}

	def private dispatch void visit(XtendFunction function) {
		function.annotations.forEach[
			storage.add(function)
		]
	}
}
