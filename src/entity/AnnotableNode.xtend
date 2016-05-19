package entity

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.core.xtend.XtendAnnotationTarget
import java.util.List
import java.util.ArrayList

class AnnotableNode
{
	new(XtendAnnotationTarget target) {
		this.sourceNode = target
		target.annotations.forEach[ xAnnotation |
			annotations.add(new Annotation(xAnnotation))
		]
	}

	/* Private */

	@Accessors var XtendAnnotationTarget sourceNode
	@Accessors val List<Annotation> annotations = new ArrayList<Annotation>
	@Accessors val List<AnnotableNode> children = new ArrayList<AnnotableNode>
}
