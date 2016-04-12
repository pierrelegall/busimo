package storage

import entity.Annotation

import org.eclipse.xtext.xbase.annotations.xAnnotations.XAnnotation
import org.eclipse.xtend.core.xtend.XtendMember
import java.util.Set
import java.util.HashSet

class AnnotationStorage
{
	def all() {
		return annotations
	}

	def add(XAnnotation annotation, XtendMember xTarget) {
		annotations.add(new Annotation(annotation, xTarget))
	}

	def add(XtendMember xTarget) {
		xTarget.annotations.forEach[ annotation |
			add(annotation, xTarget)
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
