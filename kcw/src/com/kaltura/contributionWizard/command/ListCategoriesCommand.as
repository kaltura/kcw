package com.kaltura.contributionWizard.command {
	import com.adobe_cw.adobe.cairngorm.commands.ICommand;
	import com.adobe_cw.adobe.cairngorm.control.CairngormEvent;
	import com.kaltura.commands.MultiRequest;
	import com.kaltura.commands.category.CategoryGet;
	import com.kaltura.commands.category.CategoryList;
	import com.kaltura.contributionWizard.model.WizardModelLocator;
	import com.kaltura.contributionWizard.vo.CategoryVO;
	import com.kaltura.dataStructures.HashMap;
	import com.kaltura.errors.KalturaError;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.vo.KalturaCategory;
	import com.kaltura.vo.KalturaCategoryFilter;
	import com.kaltura.vo.KalturaCategoryListResponse;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.resources.ResourceManager;
	import mx.rpc.IResponder;

	/**
	 * This class sends request to categories list from the server, and handles the response.
	 * @author Michal
	 *
	 */
	public class ListCategoriesCommand implements ICommand, IResponder {
		private var _model:WizardModelLocator = WizardModelLocator.getInstance();


		public function execute(event:CairngormEvent):void {
			//only one list categories per each CW
			if (!_model.categoriesUploaded) {
				_model.loadingFlag = true;
				var mr:MultiRequest = new MultiRequest();

				// get the root category if any
				if (_model.categoriesRootId) {
					var cget:CategoryGet = new CategoryGet(_model.categoriesRootId);
					mr.addAction(cget);
				}
				
				// get the rest of the categories
				var filter:KalturaCategoryFilter = new KalturaCategoryFilter();
				filter.fullNameStartsWith = "aa"; // need to add a value here so MR will process this
				
				var listCategories:CategoryList = new CategoryList(filter);
				mr.addAction(listCategories);

				if (_model.categoriesRootId) {
					mr.mapMultiRequestParam(1, "fullName", 2, "filter:fullNameStartsWith");
				}
				else {
					mr.addRequestParam("1:filter:fullNameStartsWith", "");
				}
				
				mr.addEventListener(KalturaEvent.COMPLETE, result);
				mr.addEventListener(KalturaEvent.FAILED, fault);
				_model.context.kc.post(mr);
				_model.categoriesUploaded = true;
			}
		}


		/**
		 * Handles a fault response
		 * @param info is the data returned from the server
		 *
		 */
		public function fault(info:Object):void {
			_model.loadingFlag = false;
			Alert.show(info.error.errorMsg, ResourceManager.getInstance().getString('Tagging', 'ERROR'));
		}


		/**
		 * Handles a result from server
		 * @param event
		 *
		 */
		public function result(info:Object):void {
			var event:KalturaEvent = info as KalturaEvent;
			_model.loadingFlag = false;

			var rootCat:KalturaCategory;
			var kclr:KalturaCategoryListResponse;
			
			if (_model.categoriesRootId) {
				// we will have 2 calls in MR
				if (event.data[0] is KalturaError) {
					showError((event.data[0] as KalturaError).errorMsg);
					return;
				}
				else if (event.data[1] is KalturaError) {
					showError((event.data[1] as KalturaError).errorMsg);
					return;
				}
				rootCat = event.data[0] as KalturaCategory;
				kclr = event.data[1] as KalturaCategoryListResponse;
			}
			else {
				// only one call
				if (event.data[0] is KalturaError) {
					showError((event.data[0] as KalturaError).errorMsg);
					return;
				}
				
				kclr = event.data[0] as KalturaCategoryListResponse;
			}
			
			var categories:ArrayCollection = new ArrayCollection(kclr.objects);
			_model.categoriesFromRoot.addAll(categories);

			// builds the category list that will be displayed on the "Tagging View" screen
			if (_model.categoriesFromRoot.length != 0)
				sortCategories(_model.categoriesFromRoot);

			// builds the prefix of the categories - the location of the category in the tree
			if (rootCat) {
				_model.categoriesPrefix = rootCat.fullName;
			}

		}


		/**
		 * sorts categories by name, alphabetically 
		 * @param catArrCol
		 */
		private function sortCategories(catArrCol:ArrayCollection):void {
			var dataSortField:SortField = new SortField();
			dataSortField.name = "name";
			dataSortField.caseInsensitive = true;
			dataSortField.descending = false;
			var dataSort:Sort = new Sort();
			dataSort.fields = [dataSortField];
			catArrCol.sort = dataSort;
			catArrCol.refresh();
		}
		
		private function showError(err:String):void {
			Alert.show(err, ResourceManager.getInstance().getString('Tagging', 'ERROR'));			
		}

	}
}
