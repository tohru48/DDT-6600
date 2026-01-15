package vip.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class PrivilegeViewItem extends Sprite implements Disposeable
   {
      
      public static const TRUE_FLASE_TYPE:int = 0;
      
      public static const UNIT_TYPE:int = 1;
      
      public static const GRAPHICS_TYPE:int = 2;
      
      public static const NORMAL_TYPE:int = 3;
      
      public static const ICON_TYPE:int = 4;
      
      private var _bg:Image;
      
      private var _seperators:Image;
      
      private var _titleTxt:FilterFrameText;
      
      private var _content:Vector.<String>;
      
      private var _displayContent:Vector.<DisplayObject>;
      
      private var _itemType:int;
      
      private var _extraDisplayObject:*;
      
      private var _extraDisplayObjectList:Vector.<DisplayObject>;
      
      private var _interceptor:Function;
      
      private var _analyzeFunction:Function;
      
      private var _crossFilter:String = "0";
      
      public function PrivilegeViewItem(type:int = 3, object:* = null)
      {
         super();
         this._itemType = type;
         this._extraDisplayObject = object;
         this._extraDisplayObjectList = new Vector.<DisplayObject>();
         this._analyzeFunction = this.analyzeContent;
         if(this._itemType == 4)
         {
            this._analyzeFunction = this.analyzeContentForTypeIcon;
         }
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemBg");
         this._seperators = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemSeperators");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemTitleTxt");
         addChild(this._bg);
         addChild(this._seperators);
         addChild(this._titleTxt);
      }
      
      protected function analyzeContentForTypeIcon(content:Array) : Vector.<DisplayObject>
      {
         var result:Vector.<DisplayObject> = null;
         var startPos:Point = null;
         var info:ItemTemplateInfo = null;
         var bg:Bitmap = null;
         var lv:int = 0;
         var icon:BaseCell = null;
         result = new Vector.<DisplayObject>();
         startPos = ComponentFactory.Instance.creatCustomObject("vip.levelPrivilegeItemTxtStartPos2");
         for(var i:int = 0; i < content.length; i++)
         {
            info = content[i] as ItemTemplateInfo;
            lv = i + 1;
            bg = ComponentFactory.Instance.creat("vip.reward.lv" + lv);
            icon = new BaseCell(bg);
            icon.info = info;
            icon.getContent().visible = false;
            PositionUtils.setPos(icon,startPos);
            startPos.x += icon.width + 7;
            result.push(icon);
         }
         return result;
      }
      
      protected function analyzeContent(content:Vector.<String>) : Vector.<DisplayObject>
      {
         var result:Vector.<DisplayObject> = null;
         var con:String = null;
         var txt:FilterFrameText = null;
         var crossImg:Image = null;
         var img:DisplayObject = null;
         var sprite:Sprite = null;
         var dis:DisplayObject = null;
         result = new Vector.<DisplayObject>();
         var startPos:Point = ComponentFactory.Instance.creatCustomObject("vip.levelPrivilegeItemTxtStartPos");
         for each(con in content)
         {
            txt = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItemTxt");
            txt.text = this._interceptor == null ? con : this._interceptor(con);
            PositionUtils.setPos(txt,startPos);
            startPos.x += txt.width + 5;
            if(con == this._crossFilter)
            {
               crossImg = ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.cross");
               crossImg.x = txt.width - crossImg.width + txt.x;
               crossImg.y = txt.y;
               result.push(crossImg);
            }
            else
            {
               switch(this._itemType)
               {
                  case TRUE_FLASE_TYPE:
                     img = con == "1" ? ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.Tick") : ComponentFactory.Instance.creatComponentByStylename("vip.PrivilegeViewItem.cross");
                     img.x = txt.width - img.width + txt.x;
                     img.y = txt.y;
                     result.push(img);
                     break;
                  case UNIT_TYPE:
                     txt.text += String(this._extraDisplayObject);
                     break;
                  case GRAPHICS_TYPE:
                     sprite = new Sprite();
                     dis = ComponentFactory.Instance.creatBitmap(this._extraDisplayObject);
                     this._extraDisplayObjectList.push(dis);
                     this._extraDisplayObjectList.push(txt);
                     txt.width -= dis.width;
                     dis.x = txt.width + txt.x;
                     dis.y = txt.y;
                     sprite.addChild(txt);
                     sprite.addChild(dis);
                     result.push(sprite);
                     break;
               }
               result.push(txt);
            }
         }
         return result;
      }
      
      public function set crossFilter(value:String) : void
      {
         this._crossFilter = value;
      }
      
      public function set contentInterceptor(value:Function) : void
      {
         this._interceptor = value;
      }
      
      public function set itemTitleText(value:String) : void
      {
         this._titleTxt.text = value;
         if(this._titleTxt.numLines > 1)
         {
            this._titleTxt.y -= 7;
         }
      }
      
      public function set analyzeFunction(val:Function) : void
      {
         this._analyzeFunction = val;
      }
      
      public function set itemContent(contents:Vector.<String>) : void
      {
         this._content = contents;
         this._displayContent = this._analyzeFunction(this._content);
         this.updateView();
      }
      
      public function set itemContentForIcontype(contents:Array) : void
      {
         this._displayContent = this._analyzeFunction(contents);
         this.updateView();
      }
      
      private function updateView() : void
      {
         var dis:DisplayObject = null;
         for each(dis in this._displayContent)
         {
            addChild(dis);
         }
      }
      
      public function dispose() : void
      {
         var dis:DisplayObject = null;
         var o:DisplayObject = null;
         if(this._displayContent != null)
         {
            for each(o in this._displayContent)
            {
               ObjectUtils.disposeObject(o);
            }
         }
         this._displayContent = null;
         for each(dis in this._extraDisplayObjectList)
         {
            ObjectUtils.disposeObject(dis);
         }
         this._extraDisplayObjectList = null;
         ObjectUtils.disposeObject(this._bg);
         ObjectUtils.disposeObject(this._seperators);
         ObjectUtils.disposeObject(this._titleTxt);
         this._bg = null;
         this._seperators = null;
         this._titleTxt = null;
      }
   }
}

