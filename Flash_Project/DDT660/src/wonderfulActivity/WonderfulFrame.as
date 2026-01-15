package wonderfulActivity
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import flash.utils.Dictionary;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import mysteriousRoullete.MysteriousManager;
   import treasureHunting.TreasureManager;
   import wonderfulActivity.data.ActivityCellVo;
   import wonderfulActivity.views.ActivityLeftView;
   import wonderfulActivity.views.WonderfulRightView;
   
   public class WonderfulFrame extends Frame
   {
      
      private var _bag:ScaleBitmapImage;
      
      private var _leftView:ActivityLeftView;
      
      private var _rightView:WonderfulRightView;
      
      private var allMusic:Boolean;
      
      public function WonderfulFrame()
      {
         super();
         escEnable = true;
         this.allMusic = SharedManager.Instance.allowMusic;
         SharedManager.Instance.allowMusic = false;
         SharedManager.Instance.changed();
         this.initview();
         this.addEvents();
      }
      
      public function setState(type:int, id:int) : void
      {
         if(!this._rightView && !this._rightView.parent)
         {
            return;
         }
         this._rightView.setState(type,id);
      }
      
      private function initview() : void
      {
         titleText = LanguageMgr.GetTranslation("wonderfulActivityManager.tittle");
         this._bag = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.scale9cornerImageTree");
         addToContent(this._bag);
         this._leftView = new ActivityLeftView();
         this._leftView.x = 22;
         this._leftView.y = 46;
         addToContent(this._leftView);
         this._rightView = new WonderfulRightView();
         addToContent(this._rightView);
         this._leftView.setRightView(this._rightView.updateView);
      }
      
      private function addEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      public function addElement(actArr:Array) : void
      {
         var vo:ActivityCellVo = null;
         var id:String = null;
         var wonderArr:Array = [];
         var limitArr:Array = [];
         var newServerArr:Array = [];
         var infoDic:Dictionary = WonderfulActivityManager.Instance.leftViewInfoDic;
         for each(id in actArr)
         {
            vo = new ActivityCellVo();
            vo.id = id;
            vo.activityName = infoDic[id].label;
            switch(infoDic[id].unitIndex)
            {
               case 1:
                  limitArr.push(vo);
                  break;
               case 2:
                  wonderArr.push(vo);
                  break;
               case 3:
                  newServerArr.push(vo);
                  break;
            }
         }
         if(newServerArr.length == 0)
         {
            this._leftView.isNewServerExist = false;
         }
         else
         {
            this._leftView.isNewServerExist = true;
         }
         this._leftView.addUnitByType(wonderArr,2);
         this._leftView.addUnitByType(limitArr,1);
         if(this._leftView.isNewServerExist)
         {
            this._leftView.addUnitByType(newServerArr,3);
         }
         else
         {
            this._leftView.checkNewServerExist();
         }
         this._leftView.extendUnitView();
      }
      
      private function _response(evt:FrameEvent) : void
      {
         if(!WonderfulActivityManager.Instance.isRuning)
         {
            return;
         }
         if(evt.responseCode == FrameEvent.CLOSE_CLICK || evt.responseCode == FrameEvent.ESC_CLICK)
         {
            if(WonderfulActivityManager.Instance.frameCanClose)
            {
               SoundManager.instance.play("008");
               this.clear();
            }
         }
      }
      
      private function clear() : void
      {
         TreasureManager.instance.dispose();
         if(MysteriousManager.instance.isMysteriousClose)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.MYSTERIOUROULETTE,false);
         }
         this.dispose();
         WonderfulActivityManager.Instance.dispose();
      }
      
      override public function dispose() : void
      {
         if(!WonderfulActivityManager.Instance.isRuning)
         {
            return;
         }
         SharedManager.Instance.allowMusic = this.allMusic;
         SharedManager.Instance.changed();
         this.removeEvents();
         ObjectUtils.disposeObject(this._leftView);
         ObjectUtils.disposeObject(this._rightView);
         this._leftView = null;
         this._rightView = null;
         super.dispose();
      }
   }
}

