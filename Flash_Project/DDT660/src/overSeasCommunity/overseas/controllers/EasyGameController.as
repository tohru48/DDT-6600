package overSeasCommunity.overseas.controllers
{
   import ddt.data.player.SelfInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import overSeasCommunity.OverSeasCommunController;
   import overSeasCommunity.overseas.model.BaseCommunityModel;
   
   public class EasyGameController extends BaseCommunityController
   {
      
      public function EasyGameController(model:BaseCommunityModel)
      {
         super(model);
         openTypeIDList = [1,2,5,13,16,17,18,19];
      }
      
      override public function sendDynamic() : void
      {
         this.getFeedParam(_model.typeId);
         super.sendDynamic();
      }
      
      override protected function getFeedParam($typeID:int) : *
      {
         var self:SelfInfo = PlayerManager.Instance.Self;
         switch($typeID)
         {
            case 1:
               OverSeasCommunController.instance().sendToAgent(2,self.ID,self.NickName,ServerManager.Instance.current.Name,self.Grade);
               break;
            case 2:
               OverSeasCommunController.instance().sendToAgent(3,self.ID,self.NickName,ServerManager.Instance.current.Name,int(_model.backgroundServerTxt));
               break;
            case 11:
               OverSeasCommunController.instance().sendToAgent(10,self.ID,self.NickName,ServerManager.Instance.current.Name);
               break;
            case 13:
               OverSeasCommunController.instance().sendToAgent(1,self.ID,self.NickName,ServerManager.Instance.current.Name);
               break;
            case 15:
               OverSeasCommunController.instance().sendToAgent(9,self.ID,self.NickName,ServerManager.Instance.current.Name,-1,_model.backgroundServerTxt);
               break;
            case 16:
               OverSeasCommunController.instance().sendToAgent(4,self.ID,self.NickName,ServerManager.Instance.current.Name,-1,PlayerManager.Instance.Self.ConsortiaName);
               break;
            case 17:
               OverSeasCommunController.instance().sendToAgent(5,self.ID,self.NickName,ServerManager.Instance.current.Name,-1,PlayerManager.Instance.Self.ConsortiaName);
               break;
            case 18:
               OverSeasCommunController.instance().sendToAgent(7,self.ID,self.NickName,ServerManager.Instance.current.Name,-1,"",PlayerManager.Instance.Self.SpouseName);
               break;
            case 19:
               OverSeasCommunController.instance().sendToAgent(8,self.ID,self.NickName,ServerManager.Instance.current.Name,-1,"",PlayerManager.Instance.Self.SpouseName);
         }
         return null;
      }
   }
}

