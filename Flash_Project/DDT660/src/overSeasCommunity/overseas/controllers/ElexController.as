package overSeasCommunity.overseas.controllers
{
	import ddt.manager.LanguageMgr;
	import ddt.manager.PlayerManager;
	import ddt.manager.ServerManager;
	import flash.external.ExternalInterface;
	import overSeasCommunity.OverSeasCommunController;
	import overSeasCommunity.overseas.model.BaseCommunityModel;
	
	public class ElexController extends BaseCommunityController
	{
		
		public function ElexController(model:BaseCommunityModel)
		{
			super(model);
			openTypeIDList = [1,2,5,13,16,17,18,19];
		}
		
		override public function sendDynamic() : void
		{
			if(ExternalInterface.available && Boolean(OverSeasCommunController.instance().elexOverseasCommunity_CallJS()))
			{
				ExternalInterface.call(OverSeasCommunController.instance().elexOverseasCommunity_CallJS(),"postFeed",this.getFeedParam(OverSeasCommunController.instance().model.typeId));
			}
			super.sendDynamic();
		}
		
		override protected function getFeedParam($typeID:int) : *
		{
			var rstVar:Object = new Object();
			switch($typeID)
			{
				case 1:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.GradeUp.Title_1",ServerManager.Instance.current.Name,PlayerManager.Instance.Self.Grade);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.GradeUp.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.GradeUp.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.GradeUp.img_1");
					break;
				case 2:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.Strengthen.Title_1",ServerManager.Instance.current.Name,_model.backgroundServerTxt);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.Strengthen.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.Strengthen.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.Strengthen.img_1");
					break;
				case 5:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.SimpleFB.Title_1",ServerManager.Instance.current.Name,_model.backgroundServerTxt);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.SimpleFB.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.SimpleFB.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.SimpleFB.img_1");
					break;
				case 13:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.FirstLogin.Title_1",ServerManager.Instance.current.Name);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.FirstLogin.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.FirstLogin.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.FirstLogin.img_1");
					break;
				case 16:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.CreatConsortia.Title_1",ServerManager.Instance.current.Name,PlayerManager.Instance.Self.ConsortiaName);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.CreatConsortia.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.CreatConsortia.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.CreatConsortia.img_1");
					break;
				case 17:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.JoinConsortia.Title_1",ServerManager.Instance.current.Name,PlayerManager.Instance.Self.ConsortiaName);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.JoinConsortia.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.JoinConsortia.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.JoinConsortia.img_1");
					break;
				case 18:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.Marry.Title_1",ServerManager.Instance.current.Name,PlayerManager.Instance.Self.SpouseName);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.Marry.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.Marry.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.Marry.img_1");
					break;
				case 19:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.Wedding.Title_1",ServerManager.Instance.current.Name,PlayerManager.Instance.Self.SpouseName);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.Wedding.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.Wedding.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.Wedding.img_1");
					break;
				case 20:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.Divorce.Title_1",PlayerManager.Instance.Self.NickName,_model.backgroundServerTxt);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.Divorce.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.Divorce.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.Divorce.img_1");
					break;
				case 21:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.DailySignIn.Title_1",ServerManager.Instance.current.Name);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.DailySignIn.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.DailySignIn.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.DailySignIn.img_1");
					break;
				case 22:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.ItemRecycle.Title_1",ServerManager.Instance.current.Name);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.ItemRecycle.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.ItemRecycle.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.ItemRecycle.img_1");
					break;
				case 23:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.ItemDrop.Title_1",ServerManager.Instance.current.Name);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.ItemDrop.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.ItemDrop.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.ItemDrop.img_1");
					break;
				case 24:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.BeApprentice.Title_1",ServerManager.Instance.current.Name);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.BeApprentice.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.BeApprentice.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.BeApprentice.img_1");
					break;
				case 24:
					rstVar.title = LanguageMgr.GetTranslation("share.feed.TakeApprentice.Title_1",ServerManager.Instance.current.Name);
					rstVar.body = LanguageMgr.GetTranslation("share.feed.TakeApprentice.Content_1");
					rstVar.title_link = LanguageMgr.GetTranslation("share.feed.TakeApprentice.title_link_1");
					rstVar.img = LanguageMgr.GetTranslation("share.feed.TakeApprentice.img_1");
			}
			return null;
			//return JSON.encode(rstVar);
		}
	}
}

