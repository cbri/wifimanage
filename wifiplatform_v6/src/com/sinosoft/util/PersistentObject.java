package com.sinosoft.util;

import java.io.Serializable;

import org.apache.commons.lang.builder.ToStringBuilder;

public abstract class PersistentObject<K extends Serializable> implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	public abstract K getPoid();
	
	public abstract void setPoid(K poid);
	
	@Override
	public int hashCode() {
		return 31 + (getPoid() == null ? 0 : getPoid().hashCode());
	}
	
	@Override
	public boolean equals(Object obj){
		if(this == obj)
			return true;
		if(obj == null)
			return false;
		try {
			PersistentObject<?> other = (PersistentObject<?>)obj;
			if ((getPoid() != null) && (other.getPoid() != null)) {
				return getPoid().equals(other.getPoid());
			}
			return false;
		} catch (Exception e) {
			return false;
		}
	}
	
	@Override
	public String toString(){
		return new ToStringBuilder(this).append("poid", getPoid()).toString();
	}
}
