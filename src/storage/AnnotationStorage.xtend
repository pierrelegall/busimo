package storage

import entity.Annotation

import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.eclipse.xtend.core.xtend.XtendAnnotationTarget
import java.util.Set
import java.util.HashSet

/**
 * An annotation storage, see it as a custom collection
 */
class AnnotationStorage
{
	/**
	 * Get the collection of all annoations
	 */
	def all() {
		return annotations
	}

	/**
	 * Add all the annotations
	 */
	def add(XAnnotation annotation, XtendAnnotationTarget xTarget, AnnotationStorage subAnnotations) {
		annotations.add(new Annotation(annotation, xTarget, subAnnotations))
	}

	/**
	 * Add all the annotations
	 */
	def add(XAnnotation annotation, XtendAnnotationTarget xTarget) {
		annotations.add(new Annotation(annotation, xTarget, new AnnotationStorage))
	}

	/**
	 * Add all the annotations of one XtendAnnotationTarget
	 */
	def add(XtendAnnotationTarget xTarget, AnnotationStorage subAnnotations) {
		xTarget.annotations.forEach[ annotation |
			add(annotation, xTarget, subAnnotations)
		]
	}

	/**
	 * Add all the annotations of one XtendAnnotationTarget
	 */
	def add(XtendAnnotationTarget xTarget) {
		xTarget.annotations.forEach[ annotation |
			add(annotation, xTarget, new AnnotationStorage)
		]
	}

	/**
	 * Remove an annotation
	 */
	def remove(Annotation annotation) {
		annotations.remove(annotation)
	}

	/**
	 * Remove an annotation
	 */
	def remove(XAnnotation xAnnotation) {
		annotations.remove(annotations.findFirst[ annotation |
			annotation.XAnnotation == xAnnotation
		])
	}

	/* Private */

	val Set<Annotation> annotations = new HashSet<Annotation>
}
