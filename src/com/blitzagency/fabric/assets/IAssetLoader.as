package com.blitzagency.fabric.assets {
	
	/*
	 * @author Patrick Matte
	 * @since 1.0 02/18/2009
	 * @version 1.0 02/18/2009
	*/
	
	/**
	* IAssetLoader is an interface for the AssetLoader class.
	* <p/>
	* All assetloaders should implement this interface
	*/
	public interface IAssetLoader extends IAsset {
		
		/**
		* Adds an asset to the asset list.
		* @param asset - A class extending Asset or implementing IAsset.
		*/
		function push(asset:IAsset):void;
		
	}
	
}