package entity

import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.eclipse.xtend.core.xtend.XtendMember
import org.eclipse.xtend.lib.annotations.Accessors

class Annotation
{
	new(XAnnotation xAnnotation, XtendMember xTarget) {
		this.xAnnotation = xAnnotation
		this.xTarget = xTarget
	}

	def override hashCode() {
		return this.xAnnotation.hashCode
	}

	/* Private */

	@Accessors var XAnnotation xAnnotation
	@Accessors var XtendMember xTarget
}
