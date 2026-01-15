package ddt.view.caddyII.items
{
   import bagAndInfo.cell.PersonalInfoCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class AwardListItem extends Sprite implements Disposeable
   {
      
      private var _userNameTxt:FilterFrameText;
      
      private var _goodsNameTxt:FilterFrameText;
      
      private var _bitMapTxt:FilterFrameText;
      
      private var _bitMap:Bitmap;
      
      private var _content:Sprite;
      
      private var _bg:ScaleFrameImage;
      
      public function AwardListItem()
      {
         super();
      }
      
      public function initView(userName:String, goodsName:String, url:String, number:int) : void
      {
         var line1:Bitmap = null;
         var line2:Bitmap = null;
         line1 = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         line1.x = 148;
         line1.y = 1;
         line2 = ComponentFactory.Instance.creatBitmap("asset.corel.formLineBig");
         line2.x = 362;
         line2.y = 1;
         this._bg = ComponentFactory.Instance.creat("caddy.badLuck.paihangItemBG");
         this._bg.setFrame(number % 2 + 1);
         this._bg.width = 580;
         this._bg.height = 31;
         addChild(this._bg);
         if(number > 3)
         {
            this._bitMapTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.numbTxt");
            this._bitMapTxt.x = 54;
            this._bitMapTxt.y = 6;
            this._bitMapTxt.text = number + "th";
            addChild(this._bitMapTxt);
            this._bitMapTxt.visible = false;
         }
         else
         {
            this._bitMap = ComponentFactory.Instance.creatBitmap("asset.awardSystem.th" + number);
            this._bitMap.x = 45;
            this._bitMap.y = 2;
            addChild(this._bitMap);
            this._bitMap.visible = false;
         }
         this._userNameTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.userNameTxt");
         this._userNameTxt.x = 206;
         this._userNameTxt.y = 5;
         this._userNameTxt.text = userName;
         addChild(this._userNameTxt);
         this._userNameTxt.visible = false;
         this._goodsNameTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.goodsNametxt");
         this._goodsNameTxt.text = goodsName;
         this._goodsNameTxt.x = 414;
         this._goodsNameTxt.y = 5;
         addChild(this._goodsNameTxt);
         this._goodsNameTxt.visible = false;
         addChild(line1);
         addChild(line2);
      }
      
      public function upDataUserName(obj:Object) : void
      {
         var info:InventoryItemInfo = null;
         var infoI:ItemTemplateInfo = null;
         var cell:PersonalInfoCell = null;
         var item:InventoryItemInfo = null;
         var itemI:ItemTemplateInfo = null;
         if(Boolean(this._userNameTxt))
         {
            if(Boolean(this._bitMapTxt))
            {
               this._bitMapTxt.visible = true;
            }
            if(Boolean(this._bitMap))
            {
               this._bitMap.visible = true;
            }
            this._userNameTxt.visible = true;
            this._goodsNameTxt.visible = true;
            if(Boolean(obj["Nickname"]))
            {
               this._userNameTxt.text = obj["Nickname"];
            }
            info = new InventoryItemInfo();
            infoI = ItemManager.Instance.getTemplateById(obj["TemplateID"]);
            ObjectUtils.copyProperties(info,infoI);
            if(Boolean(info))
            {
               cell = new PersonalInfoCell();
               cell.x = 525;
               cell.y = 4;
               cell.tipGapH = -10;
               cell.tipGapV = -40;
               cell.scaleX = cell.scaleY = 0.5;
               item = new InventoryItemInfo();
               itemI = ItemManager.Instance.getTemplateById(obj["TemplateID"]);
               ObjectUtils.copyProperties(item,itemI);
               if(item.TemplateID == 70244 || item.TemplateID == 17100)
               {
                  item.StrengthenLevel = 12;
               }
               if(item.TemplateID != 17100)
               {
                  item.AttackCompose = item.DefendCompose = item.AgilityCompose = item.LuckCompose = 50;
               }
               item.IsBinds = true;
               item.ValidDate = 23;
               cell.info = item;
               if(obj["count"] != 0)
               {
                  this._goodsNameTxt.text = cell.info.Name + "x" + obj["count"];
               }
               else
               {
                  this._goodsNameTxt.text = cell.info.Name;
               }
               this._goodsNameTxt.text = cell.info.Name;
               addChild(cell);
            }
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._userNameTxt = null;
         this._goodsNameTxt = null;
         this._bitMapTxt = null;
         this._content = null;
         this._bitMap = null;
         this._bg = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

