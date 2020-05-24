package org.xtext.mdsd.external.util

import java.util.ArrayList
import org.eclipse.emf.ecore.EObject
import org.xtext.mdsd.external.util.QCOriginResolver.QCJsonOrigin

class QCOrigin {

	public QCJsonOrigin origin
	public ArrayList<EObject> references

	new(QCJsonOrigin origin, ArrayList<EObject> references) {
		this.origin = origin
		this.references = references

	}
}
