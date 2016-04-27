package entity

import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.eclipse.xtend.core.xtend.XtendAnnotationTarget
import org.eclipse.xtend.lib.annotations.Accessors

import storage.AnnotationStorage

/**
 * Abstraction of the concept of an annotation use in Busimo.
 */
class Annotation
{
	/**
	 * The constructor
	 */
	new(XAnnotation xAnnotation, XtendAnnotationTarget xTarget, AnnotationStorage subAnnotations) {
		this.xAnnotation = xAnnotation
		this.xTarget = xTarget
		this.subAnnotations = subAnnotations
	}

	/**
	 * The constructor with subAnnotations empty
	 */
	new(XAnnotation xAnnotation, XtendAnnotationTarget xTarget) {
		this.xAnnotation = xAnnotation
		this.xTarget = xTarget
		this.subAnnotations = new AnnotationStorage
	}

	/**
	 * The hashcode is the hashcode of the XAnnotation
	 */
	override hashCode() {
		return this.xAnnotation.hashCode
	}

	/* Private */

	@Accessors var XAnnotation xAnnotation
	@Accessors var XtendAnnotationTarget xTarget
	@Accessors var AnnotationStorage subAnnotations
}
