package auctionHouse.view
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class VerticalMenu extends Sprite implements Disposeable
   {
      
      public static const MENU_CLICKED:String = "menuClicked";
      
      public static const MENU_REFRESH:String = "menuRefresh";
      
      private var tabWidth:Number;
      
      private var l1Width:Number;
      
      private var l2Width:Number;
      
      private var subMenus:Array;
      
      private var rootMenu:Array;
      
      public var currentItem:IMenuItem;
      
      public var isseach:Boolean;
      
      private var _height:int;
      
      public function VerticalMenu($tabWidth:Number, $l1Width:Number, $l2Width:Number)
      {
         super();
         this.tabWidth = $tabWidth;
         this.l1Width = $l1Width;
         this.l2Width = $l2Width;
         this.rootMenu = [];
         this.subMenus = [];
      }
      
      public function addItemAt($item:IMenuItem, parentIndex:int = -1) : void
      {
         var i:uint = 0;
         if(parentIndex == -1)
         {
            this.rootMenu.push($item);
            $item.addEventListener(MouseEvent.CLICK,this.rootMenuClickHandler);
         }
         else
         {
            if(!this.subMenus[parentIndex])
            {
               for(i = 0; i <= parentIndex; i++)
               {
                  if(!this.subMenus[i])
                  {
                     this.subMenus[i] = [];
                  }
               }
            }
            $item.x = this.tabWidth;
            $item.addEventListener(MouseEvent.CLICK,this.subMenuClickHandler);
            this.subMenus[parentIndex].push($item);
         }
         addChild($item as DisplayObject);
         this.closeAll();
      }
      
      public function closeAll() : void
      {
         var i2:uint = 0;
         for(var i:uint = 0; i < this.rootMenu.length; i++)
         {
            this.rootMenu[i].y = i * this.l1Width;
            this.rootMenu[i].isOpen = false;
            this.rootMenu[i].enable = true;
         }
         for(var i1:uint = 0; i1 < this.subMenus.length; i1++)
         {
            for(i2 = 0; i2 < this.subMenus[i1].length; i2++)
            {
               this.subMenus[i1][i2].visible = false;
               this.subMenus[i1][i2].y = 0;
            }
         }
         this._height = this.rootMenu.length * this.l1Width;
      }
      
      public function get $height() : Number
      {
         return this._height;
      }
      
      protected function rootMenuClickHandler(e:MouseEvent) : void
      {
         var i:uint = 0;
         var j:uint = 0;
         SoundManager.instance.play("008");
         if(this.currentItem != null)
         {
            this.currentItem.enable = true;
         }
         this.currentItem = e.currentTarget as IMenuItem;
         var _index:int = int(this.rootMenu.indexOf(this.currentItem));
         if(this.currentItem.isOpen)
         {
            this.closeAll();
            this.currentItem.enable = true;
            for(i = 0; i < this.subMenus.length; i++)
            {
               for(j = 0; j < this.subMenus[i].length; j++)
               {
                  this.subMenus[i][j].enable = true;
               }
            }
         }
         else
         {
            this.closeAll();
            this.openItemByIndex(_index);
            this.isseach = false;
            this.currentItem.enable = false;
         }
         dispatchEvent(new Event(MENU_REFRESH));
      }
      
      private function closeItems() : void
      {
      }
      
      private function openItemByIndex(index:uint) : void
      {
         var i2:uint = 0;
         if(!this.subMenus[index])
         {
            return;
         }
         for(var i:uint = 0; i < this.rootMenu.length; )
         {
            if(i <= index)
            {
               this.rootMenu[i].y = i * this.l1Width;
            }
            else
            {
               this.rootMenu[i].y = i * this.l1Width + this.subMenus[index].length * this.l2Width;
            }
            i++;
         }
         for(var i1:uint = 0; i1 < this.subMenus.length; i1++)
         {
            for(i2 = 0; i2 < this.subMenus[i1].length; i2++)
            {
               if(i1 == index)
               {
                  this.subMenus[i1][i2].visible = true;
                  this.subMenus[i1][i2].enable = true;
                  this.subMenus[i1][i2].y = (index + 1) * this.l1Width + i2 * this.l2Width;
               }
               else
               {
                  this.subMenus[i1][i2].visible = false;
               }
            }
         }
         this._height = this.rootMenu.length * this.l1Width + this.subMenus[index].length * this.l2Width;
         this.rootMenu[index].isOpen = true;
      }
      
      public function dispose() : void
      {
         var i:uint = 0;
         var i1:uint = 0;
         var i2:uint = 0;
         if(Boolean(this.rootMenu))
         {
            for(i = 0; i < this.rootMenu.length; i++)
            {
               this.rootMenu[i].removeEventListener(MouseEvent.CLICK,this.rootMenuClickHandler);
               ObjectUtils.disposeObject(this.rootMenu[i]);
               this.rootMenu[i] = null;
            }
         }
         this.rootMenu = null;
         if(Boolean(this.subMenus))
         {
            for(i1 = 0; i1 < this.subMenus.length; i1++)
            {
               for(i2 = 0; i2 < this.subMenus[i1].length; i2++)
               {
                  this.subMenus[i1][i2].removeEventListener(MouseEvent.CLICK,this.subMenuClickHandler);
                  ObjectUtils.disposeObject(this.subMenus[i1][i2]);
                  this.subMenus[i1][i2] = null;
               }
            }
         }
         this.subMenus = null;
         this.currentItem = null;
         ObjectUtils.disposeAllChildren(this);
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
      
      protected function subMenuClickHandler(e:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.isseach = true;
         if(Boolean(this.currentItem))
         {
            this.currentItem.enable = true;
         }
         this.currentItem = e.currentTarget as IMenuItem;
         this.currentItem.enable = false;
         dispatchEvent(new Event(MENU_CLICKED));
      }
   }
}

