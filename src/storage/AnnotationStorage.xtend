package storage

import entity.Annotation

import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.eclipse.xtend.core.xtend.XtendAnnotationTarget
import java.util.Set
import java.util.HashSet

class AnnotationStorage
{
	def all() {
		return annotations
	}

	def add(XAnnotation annotation, XtendAnnotationTarget xTarget, AnnotationStorage subAnnotations) {
		annotations.add(new Annotation(annotation, xTarget, subAnnotations))
	}

	def add(XAnnotation annotation, XtendAnnotationTarget xTarget) {
		annotations.add(new Annotation(annotation, xTarget, new AnnotationStorage))
	}

	def add(XtendAnnotationTarget xTarget, AnnotationStorage subAnnotations) {
		xTarget.annotations.forEach[ annotation |
			add(annotation, xTarget, subAnnotations)
		]
	}

	def add(XtendAnnotationTarget xTarget) {
		xTarget.annotations.forEach[ annotation |
			add(annotation, xTarget, new AnnotationStorage)
		]
	}

	def remove(Annotation annotation) {
		annotations.remove(annotation)
	}

	def remove(XAnnotation xAnnotation) {
		annotations.remove(annotations.findFirst[ annotation |
			annotation.XAnnotation == xAnnotation
		])
	}

	/* Private */

	val Set<Annotation> annotations = new HashSet<Annotation>
}
