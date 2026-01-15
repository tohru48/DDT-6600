package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import im.info.CustomInfo;
   
   public class FriendGroupTip extends Sprite implements Disposeable
   {
      
      private var _bg:ScaleBitmapImage;
      
      private var _vbox:VBox;
      
      private var _itemArr:Array;
      
      public function FriendGroupTip()
      {
         super();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("friendsGroupTip.bg");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("friendsGroupTip.ItemContainer");
         addChild(this._bg);
         addChild(this._vbox);
         this._itemArr = new Array();
      }
      
      public function update(nickName:String) : void
      {
         var item:FriendGroupTItem = null;
         this.clearItem();
         var customList:Vector.<CustomInfo> = PlayerManager.Instance.customList;
         for(var i:int = 0; i < customList.length - 1; i++)
         {
            item = new FriendGroupTItem();
            item.info = customList[i];
            item.NickName = nickName;
            this._vbox.addChild(item);
            this._itemArr.push(item);
         }
         this._bg.height = customList.length * 21;
      }
      
      private function clearItem() : void
      {
         for(var i:int = 0; i < this._itemArr.length; i++)
         {
            if(Boolean(this._itemArr[i]))
            {
               ObjectUtils.disposeObject(this._itemArr[i]);
            }
            this._itemArr[i] = null;
         }
         this._itemArr = new Array();
      }
      
      public function dispose() : void
      {
         this.clearItem();
         this._itemArr = null;
         if(Boolean(this._vbox))
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(Boolean(this._bg))
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

