package entity

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.eclipse.xtend.core.xtend.XtendAnnotationTarget
import org.eclipse.xtext.common.types.JvmType

/**
 * Abstraction of the concept of an annotation use in Busimo.
 */
class Annotation
{
	new(XAnnotation xAnnotation, XtendAnnotationTarget target) {
		this.type = xAnnotation.annotationType
		this.target = target
	}

	/* Private */

	@Accessors var JvmType type
	@Accessors var XtendAnnotationTarget target
}
