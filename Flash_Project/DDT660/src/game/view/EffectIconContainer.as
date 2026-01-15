package game.view
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import game.view.effects.BaseMirariEffectIcon;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   [Event(name="change",type="flash.events.Event")]
   public class EffectIconContainer extends Sprite
   {
      
      private var _data:DictionaryData;
      
      private var _spList:Array;
      
      private var _list:Vector.<BaseMirariEffectIcon> = new Vector.<BaseMirariEffectIcon>();
      
      public function EffectIconContainer()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         this.initialize();
         this.initEvent();
      }
      
      private function initialize() : void
      {
         if(Boolean(this._spList) || Boolean(this._data))
         {
            this.release();
         }
         this._data = new DictionaryData();
         this._spList = [];
      }
      
      private function release() : void
      {
         this.clearIcons();
         if(Boolean(this._data))
         {
            this.removeEvent();
            this._data.clear();
         }
         this._data = null;
      }
      
      private function clearIcons() : void
      {
         var sp:DisplayObject = null;
         for each(sp in this._spList)
         {
            removeChild(sp);
         }
         this._spList = [];
      }
      
      private function drawIcons(iconArr:Array) : void
      {
         var i:int = 0;
         var icon:DisplayObject = null;
         for(i = 0; i < iconArr.length; i++)
         {
            icon = this._data.list[i];
            icon.x = (i & 3) * 21;
            icon.y = (i >> 2) * 21;
            this._spList.push(icon);
            addChild(icon);
         }
      }
      
      private function initEvent() : void
      {
         this._data.addEventListener(DictionaryEvent.ADD,this.__changeEffectHandler);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__changeEffectHandler);
      }
      
      private function removeEvent() : void
      {
         if(Boolean(this._data))
         {
            this._data.removeEventListener(DictionaryEvent.ADD,this.__changeEffectHandler);
            this._data.removeEventListener(DictionaryEvent.REMOVE,this.__changeEffectHandler);
         }
      }
      
      private function __changeEffectHandler(e:DictionaryEvent) : void
      {
         var sp:Sprite = e.data as Sprite;
         this._updateList();
      }
      
      private function _updateList() : void
      {
         this.clearIcons();
         this.drawIcons(this._data.list);
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      override public function get width() : Number
      {
         return this._spList.length % 5 * 21;
      }
      
      override public function get height() : Number
      {
         return (Math.floor(this._spList.length / 5) + 1) * 21;
      }
      
      public function handleEffect(type:int, view:DisplayObject) : void
      {
         if(Boolean(view))
         {
            this._data.add(type,view);
         }
      }
      
      public function removeEffect(type:int) : void
      {
         this._data.remove(type);
      }
      
      public function clearEffectIcon() : void
      {
         this.release();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.release();
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

