package wonderfulActivity.items
{
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class LimitListItem extends Sprite
   {
      
      public static const ITEM_CHANGE:String = "itemChange";
      
      private var _info:ActiveEventsInfo;
      
      private var _btn:ScaleFrameImage;
      
      private var _txt:FilterFrameText;
      
      private var _isSeleted:Boolean;
      
      private var _func:Function;
      
      private var _selecetHander:Function;
      
      private var icon:Bitmap;
      
      public function LimitListItem(info:ActiveEventsInfo, func:Function, selecteHander:Function)
      {
         super();
         this._info = info;
         this._func = func;
         this._selecetHander = selecteHander;
         this.initView();
         this.initIcon();
      }
      
      private function initView() : void
      {
         this._btn = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.back");
         addEventListener(MouseEvent.CLICK,this.clickHander);
         addChild(this._btn);
         buttonMode = true;
         useHandCursor = true;
         this.initTxt();
      }
      
      public function setSelectBtn(bool:Boolean) : void
      {
         this._isSeleted = bool;
         DisplayUtils.setFrame(this._btn,this._isSeleted ? 2 : 1);
         this.initTxt();
         dispatchEvent(new Event(ITEM_CHANGE));
      }
      
      private function initTxt() : void
      {
         if(Boolean(this._txt))
         {
            ObjectUtils.disposeObject(this._txt);
            this._txt = null;
         }
         if(this._isSeleted)
         {
            this._txt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.seleBtnTxt");
         }
         else
         {
            this._txt = ComponentFactory.Instance.creatComponentByStylename("wonderfulactivity.left.unseleBtnTxt");
         }
         this._txt.text = this.changeTitle();
         addChild(this._txt);
      }
      
      private function changeTitle() : String
      {
         var str:String = "";
         var title:String = "  " + this._info.Title;
         if(title.length > 11)
         {
            str = title.substr(0,11) + "...";
         }
         else
         {
            str = title;
         }
         return str;
      }
      
      public function initRightView() : Function
      {
         return this._func(this._info);
      }
      
      protected function clickHander(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._isSeleted)
         {
            return;
         }
         if(this._func != null)
         {
            this._func(this._info);
         }
         if(this._selecetHander != null)
         {
            this._selecetHander();
         }
         this.setSelectBtn(true);
         this.initTxt();
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.clickHander);
         ObjectUtils.disposeObject(this._btn);
         ObjectUtils.disposeObject(this._txt);
         ObjectUtils.disposeObject(this.icon);
         this._txt = null;
         this._btn = null;
         this._func = null;
         this.icon = null;
      }
      
      private function initIcon() : void
      {
         if(Boolean(this.icon))
         {
            ObjectUtils.disposeObject(this.icon);
            this.icon = null;
         }
         var iconId:int = this._info.IconID;
         if(iconId == 1)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_chongzhi");
         }
         else if(iconId == 2)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_qita");
         }
         else if(iconId == 3)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_duihuan");
         }
         else if(iconId == 4)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_hunli");
         }
         else if(iconId == 5)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_lingqu");
         }
         else if(iconId == 6)
         {
            this.icon = ComponentFactory.Instance.creat("wonderfulactivity.left.icon_xiaofei");
         }
         if(this.icon == null)
         {
            return;
         }
         PositionUtils.setPos(this.icon,"wonderfulactivity.left.iconPos");
         addChild(this.icon);
      }
   }
}

