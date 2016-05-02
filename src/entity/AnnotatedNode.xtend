package entity

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.core.xtend.XtendAnnotationTarget
import java.util.List
import java.util.ArrayList

class AnnotatedNode
{
	new(XtendAnnotationTarget target) {
		target.annotations.forEach[ xAnnotation |
			annotations.add(new Annotation(xAnnotation, target))
		]
	}

	/* Private */

	@Accessors val List<Annotation> annotations = new ArrayList<Annotation>
	@Accessors val List<AnnotatedNode> children = new ArrayList<AnnotatedNode>
}
