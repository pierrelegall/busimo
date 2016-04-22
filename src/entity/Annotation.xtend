package entity

import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.eclipse.xtend.core.xtend.XtendMember
import org.eclipse.xtend.core.xtend.XtendAnnotationTarget
import org.eclipse.xtend.lib.annotations.Accessors

import storage.AnnotationStorage

class Annotation
{
	new(XAnnotation xAnnotation, XtendAnnotationTarget xTarget, AnnotationStorage subAnnotations) {
		this.xAnnotation = xAnnotation
		this.xTarget = xTarget
		this.subAnnotations = subAnnotations
	}

	new(XAnnotation xAnnotation, XtendAnnotationTarget xTarget) {
		this.xAnnotation = xAnnotation
		this.xTarget = xTarget
		this.subAnnotations = new AnnotationStorage
	}

	def override hashCode() {
		return this.xAnnotation.hashCode
	}

	/* Private */

	@Accessors var XAnnotation xAnnotation
	@Accessors var XtendAnnotationTarget xTarget
	@Accessors var AnnotationStorage subAnnotations
}
