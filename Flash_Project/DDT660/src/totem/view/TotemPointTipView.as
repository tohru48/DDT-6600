package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.text.TextFormat;
   import totem.TotemManager;
   import totem.data.TotemDataVo;
   
   public class TotemPointTipView extends Sprite implements Disposeable
   {
      
      private var _bg:Bitmap;
      
      private var _propertyNameTxt:FilterFrameText;
      
      private var _propertyValueTxt:FilterFrameText;
      
      private var _propertyValueList:Array;
      
      private var _possibleValeList:Array;
      
      private var _propertyValueTextFormatList:Vector.<TextFormat>;
      
      private var _propertyValueGlowFilterList:Vector.<GlowFilter>;
      
      private var _possibleValueTxtColorList:Array = [16752450,9634815,35314,9035310,16727331];
      
      private var _honorExpSprite:Sprite;
      
      private var _honorTxt:FilterFrameText;
      
      private var _expTxt:FilterFrameText;
      
      private var _lvAddPropertyTxtSprite:Sprite;
      
      private var _lvAddPropertyTxtList:Vector.<FilterFrameText>;
      
      private var _bg2:Bitmap;
      
      private var _statusNameTxt:FilterFrameText;
      
      private var _statusValueTxt:FilterFrameText;
      
      private var _currentPropertyTxt:FilterFrameText;
      
      private var _statusValueList:Array;
      
      public function TotemPointTipView()
      {
         super();
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this.initData();
         this.initView();
      }
      
      private function initData() : void
      {
         this._propertyValueTextFormatList = new Vector.<TextFormat>();
         this._propertyValueGlowFilterList = new Vector.<GlowFilter>();
         for(var i:int = 1; i <= 7; i++)
         {
            this._propertyValueTextFormatList.push(ComponentFactory.Instance.model.getSet("totem.totemWindow.propertyName" + i + ".tf"));
            this._propertyValueGlowFilterList.push(ComponentFactory.Instance.model.getSet("totem.totemWindow.propertyName" + i + ".gf"));
         }
         this._propertyValueList = LanguageMgr.GetTranslation("ddt.totem.sevenProperty").split(",");
         this._possibleValeList = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.possibleValueTxt").split(",");
         this._statusValueList = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.statusValueTxt").split(",");
      }
      
      private function initView() : void
      {
         var i:int = 0;
         var tmpTxt:FilterFrameText = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.totem.leftView.tipBg");
         this._propertyNameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.propertyNameTxt");
         this._propertyNameTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.propertyNameTxt");
         this._propertyValueTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.propertyValueTxt");
         this._honorExpSprite = ComponentFactory.Instance.creatCustomObject("totem.totemPointTip.honorExpSprite");
         this._honorTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.honor");
         this._expTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.exp");
         this._honorExpSprite.addChild(this._honorTxt);
         this._honorExpSprite.addChild(this._expTxt);
         this._lvAddPropertyTxtSprite = ComponentFactory.Instance.creatCustomObject("totem.totemPointTip.lvAddPropertySprite");
         this._lvAddPropertyTxtList = new Vector.<FilterFrameText>();
         for(i = 0; i < 10; i++)
         {
            tmpTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.lvAddProperty");
            tmpTxt.x = i % 2 * 100;
            tmpTxt.y = int(i / 2) * 18;
            this._lvAddPropertyTxtSprite.addChild(tmpTxt);
            this._lvAddPropertyTxtList.push(tmpTxt);
         }
         this._bg2 = ComponentFactory.Instance.creatBitmap("asset.totem.leftView.tipBg2");
         this._statusNameTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.statusNameTxt");
         this._statusNameTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.statusNameTxt");
         this._statusValueTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.statusValueTxt");
         this._currentPropertyTxt = ComponentFactory.Instance.creatComponentByStylename("totem.totemPointTip.currentPropertyTxt");
         this._currentPropertyTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.currentPropertyTxt");
         addChild(this._bg);
         addChild(this._bg2);
         addChild(this._propertyNameTxt);
         addChild(this._propertyValueTxt);
         addChild(this._statusNameTxt);
         addChild(this._statusValueTxt);
         addChild(this._honorExpSprite);
         addChild(this._lvAddPropertyTxtSprite);
         addChild(this._currentPropertyTxt);
      }
      
      public function show(totemData:TotemDataVo, isCurCanClickTotem:Boolean, isLighted:Boolean) : void
      {
         var possible:int = 0;
         var tmp:TotemDataVo = null;
         var lv:int = 0;
         var index2:int = 0;
         var propertyStr:String = null;
         var value2:int = 0;
         if(isCurCanClickTotem)
         {
            this.showStatus1();
         }
         else
         {
            this.showStatus2();
         }
         var index:int = totemData.Location - 1;
         var value:int = this.getValueByIndex(index,totemData);
         this._propertyValueTxt.text = this._propertyValueList[index] + "+" + value;
         this._propertyValueTxt.setTextFormat(this._propertyValueTextFormatList[index]);
         this._propertyValueTxt.filters = [this._propertyValueGlowFilterList[index]];
         if(isCurCanClickTotem)
         {
            possible = totemData.Random;
            if(possible >= 100)
            {
               index = 0;
            }
            else if(possible >= 80 && possible < 100)
            {
               index = 1;
            }
            else if(possible >= 40 && possible < 80)
            {
               index = 2;
            }
            else if(possible >= 20 && possible < 40)
            {
               index = 3;
            }
            else
            {
               index = 4;
            }
            this._honorTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.honorTxt",totemData.ConsumeHonor);
            this._expTxt.text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.expTxt",totemData.ConsumeExp);
            if(PlayerManager.Instance.Self.myHonor < totemData.ConsumeHonor)
            {
               this._honorTxt.setTextFormat(new TextFormat(null,null,16711680));
            }
            if(PlayerManager.Instance.Self.Money < totemData.ConsumeExp)
            {
               this._expTxt.setTextFormat(new TextFormat(null,null,16711680));
            }
         }
         else if(isLighted)
         {
            this._statusValueTxt.text = this._statusValueList[0];
            this._statusValueTxt.setTextFormat(new TextFormat(null,null,15728384));
         }
         else
         {
            this._statusValueTxt.text = this._statusValueList[1];
            this._statusValueTxt.setTextFormat(new TextFormat(null,null,9408399));
         }
         var page:int = totemData.Page;
         var location:int = totemData.Location;
         var dataArray:Array = TotemManager.instance.getSamePageLocationList(page,location);
         var len:int = int(dataArray.length);
         var layer:int = totemData.Layers - 1;
         var layer2:int = totemData.Layers;
         for(var i:int = 0; i < len; i++)
         {
            tmp = dataArray[i] as TotemDataVo;
            lv = (page - 1) * 10 + tmp.Layers;
            index2 = tmp.Location - 1;
            propertyStr = this._propertyValueList[index2];
            value2 = this.getValueByIndex(index2,tmp);
            this._lvAddPropertyTxtList[i].text = LanguageMgr.GetTranslation("ddt.totem.totemPointTip.lvAddPropertyTxt",lv,propertyStr,value2);
            this._lvAddPropertyTxtList[i].setTextFormat(this._propertyValueTextFormatList[index]);
            if(isLighted && tmp.Layers <= layer2 || !isLighted && tmp.Layers <= layer)
            {
               this._lvAddPropertyTxtList[i].setTextFormat(new TextFormat(null,null,null,false));
               this._lvAddPropertyTxtList[i].filters = [this._propertyValueGlowFilterList[index]];
            }
            else
            {
               this._lvAddPropertyTxtList[i].setTextFormat(new TextFormat(null,null,11842740,false));
            }
         }
         if(isCurCanClickTotem)
         {
            PositionUtils.setPos(this._lvAddPropertyTxtSprite,"totem.totemPointTip.lvAddPropertySpritePos1");
         }
         else
         {
            PositionUtils.setPos(this._lvAddPropertyTxtSprite,"totem.totemPointTip.lvAddPropertySpritePos2");
         }
      }
      
      private function showStatus1() : void
      {
         this._bg.visible = true;
         this._bg2.visible = false;
         this._propertyNameTxt.visible = true;
         this._propertyValueTxt.visible = true;
         this._statusNameTxt.visible = false;
         this._statusValueTxt.visible = false;
         this._honorExpSprite.visible = true;
         this._lvAddPropertyTxtSprite.visible = true;
         this._currentPropertyTxt.visible = false;
      }
      
      private function showStatus2() : void
      {
         this._bg.visible = false;
         this._bg2.visible = true;
         this._propertyNameTxt.visible = true;
         this._propertyValueTxt.visible = true;
         this._statusNameTxt.visible = true;
         this._statusValueTxt.visible = true;
         this._honorExpSprite.visible = false;
         this._lvAddPropertyTxtSprite.visible = true;
         this._currentPropertyTxt.visible = true;
      }
      
      public function getValueByIndex(index:int, totemData:TotemDataVo) : int
      {
         var value:int = 0;
         switch(index)
         {
            case 0:
               value = totemData.AddAttack;
               break;
            case 1:
               value = totemData.AddDefence;
               break;
            case 2:
               value = totemData.AddAgility;
               break;
            case 3:
               value = totemData.AddLuck;
               break;
            case 4:
               value = totemData.AddBlood;
               break;
            case 5:
               value = totemData.AddDamage;
               break;
            case 6:
               value = totemData.AddGuard;
               break;
            default:
               value = 0;
         }
         return value;
      }
      
      public function dispose() : void
      {
         var tmp:FilterFrameText = null;
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._propertyNameTxt = null;
         this._propertyValueTxt = null;
         this._propertyValueList = null;
         this._possibleValeList = null;
         this._propertyValueTextFormatList = null;
         this._propertyValueGlowFilterList = null;
         ObjectUtils.disposeObject(this._honorTxt);
         this._honorTxt = null;
         ObjectUtils.disposeObject(this._expTxt);
         this._expTxt = null;
         this._honorExpSprite = null;
         for each(tmp in this._lvAddPropertyTxtList)
         {
            ObjectUtils.disposeObject(tmp);
         }
         this._lvAddPropertyTxtList = null;
         this._lvAddPropertyTxtSprite = null;
         this._bg2 = null;
         this._statusNameTxt = null;
         this._statusValueTxt = null;
         this._currentPropertyTxt = null;
         this._statusValueList = null;
         this._possibleValueTxtColorList = null;
         if(Boolean(parent))
         {
            parent.removeChild(this);
         }
      }
   }
}

