package ddt.manager
{
   import ddt.data.EquipType;
   import ddt.data.PathInfo;
   import ddt.states.StateType;
   
   public class PathManager
   {
      
      private static var info:PathInfo;
      
      public static var SITE_MAIN:String = "";
      
      public static var SITE_WEEKLY:String = "";
      
      public function PathManager()
      {
         super();
      }
      
      public static function setup(i:PathInfo) : void
      {
         info = i;
         SITE_MAIN = info.SITE;
         SITE_WEEKLY = info.WEEKLY_SITE;
      }
      
      public static function solvePhpPath() : String
      {
         return info.PHP_PATH;
      }
      
      public static function userName() : String
      {
         return info.USER_NAME;
      }
      
      public static function solveOfficialSitePath() : String
      {
         info.OFFICIAL_SITE = info.OFFICIAL_SITE.replace("{uid}",PlayerManager.Instance.Self.ID);
         return info.OFFICIAL_SITE;
      }
      
      public static function solveGameForum() : String
      {
         info.GAME_FORUM = info.GAME_FORUM.replace("{uid}",PlayerManager.Instance.Self.ID);
         return info.GAME_FORUM;
      }
      
      public static function get solveCommunityFriend() : String
      {
         return info.COMMUNITY_FRIEND_PATH;
      }
      
      public static function solveClientDownloadPath() : String
      {
         return info.CLIENT_DOWNLOAD;
      }
      
      public static function solveWebPlayerInfoPath(uid:String, code:String = "", key:String = "") : String
      {
         var url:String = info.WEB_PLAYER_INFO_PATH.replace("{uid}",uid);
         url = url.replace("{code}",code);
         return url.replace("{key}",key);
      }
      
      public static function solveFlvSound(id:String) : String
      {
         return info.SITE + "sound/" + id + ".flv";
      }
      
      public static function solveFirstPage() : String
      {
         return info.FIRSTPAGE;
      }
      
      public static function solveRegister() : String
      {
         return info.REGISTER;
      }
      
      public static function solveLogin() : String
      {
         info.LOGIN_PATH = info.LOGIN_PATH.replace("{nickName}",PlayerManager.Instance.Self.NickName);
         info.LOGIN_PATH = info.LOGIN_PATH.replace("{uid}",PlayerManager.Instance.Self.ID);
         return info.LOGIN_PATH;
      }
      
      public static function solveConfigSite() : String
      {
         return info.SITEII;
      }
      
      public static function solveFillPage() : String
      {
         info.FILL_PATH = info.FILL_PATH.replace("{nickName}",PlayerManager.Instance.Self.NickName);
         info.FILL_PATH = info.FILL_PATH.replace("{uid}",PlayerManager.Instance.Self.ID);
         return info.FILL_PATH;
      }
      
      public static function solveLoginPHP($loginName:String) : String
      {
         return info.PHP_PATH.replace("{id}",$loginName);
      }
      
      public static function checkOpenPHP() : Boolean
      {
         return info.PHP_IMAGE_LINK;
      }
      
      public static function solveTrainerPage() : String
      {
         return info.TRAINER_PATH;
      }
      
      public static function solveWeeklyPath(str:String) : String
      {
         return info.WEEKLY_SITE + "weekly/" + str;
      }
      
      public static function solveMapPath(id:int, name:String, type:String) : String
      {
         return info.SITE + "image/map/" + id.toString() + "/" + name + "." + type;
      }
      
      public static function solveMapSmallView(id:int) : String
      {
         return info.SITE + "image/map/" + id.toString() + "/small.png";
      }
      
      public static function solveRequestPath(path:String = "") : String
      {
         return info.REQUEST_PATH + path;
      }
      
      public static function solvePropPath(path:String) : String
      {
         return info.SITE + "image/tool/" + path + ".png";
      }
      
      public static function solveMapIconPath(id:int, type:int, missionPic:String = "show1.jpg") : String
      {
         var path:String = "";
         if(type == 0)
         {
            path = info.SITE + "image/map/" + id.toString() + "/icon.png";
         }
         else if(type == 1)
         {
            path = info.SITE + "image/map/" + id.toString() + "/samll_map.png";
         }
         else if(type == 2)
         {
            path = info.SITE + "image/map/" + id.toString() + "/" + missionPic;
         }
         else if(type == 3)
         {
            path = info.SITE + "image/map/" + id.toString() + "/samll_map_s.jpg";
         }
         return path;
      }
      
      public static function solveEffortIconPath(iconUrl:String) : String
      {
         var path:String = "";
         return info.SITE + "image/effort/" + iconUrl + "/icon.png";
      }
      
      public static function solveFieldPlantPath(iconUrl:String, type:int) : String
      {
         return info.SITE + "image/farm/Crops/" + iconUrl + "/crop" + type + ".png";
      }
      
      public static function solveSeedPath(iconUrl:String) : String
      {
         return info.SITE + "image/farm/Crops/" + iconUrl + "/seed.png";
      }
      
      public static function solveCountPath() : String
      {
         return info.COUNT_PATH;
      }
      
      public static function solveParterId() : String
      {
         return info.PARTER_ID;
      }
      
      public static function solveStylePath(sex:Boolean, type:String, path:String) : String
      {
         return info.SITE + info.STYLE_PATH + (sex ? "m" : "f") + "/" + type + "/" + path + ".png";
      }
      
      public static function solveArmPath(type:String, path:String) : String
      {
         return info.SITE + info.STYLE_PATH + String(type) + "/" + path + ".png";
      }
      
      public static function solveGoodsPath(category:Number, path:String, sex:Boolean = true, pictype:String = "show", dressHat:String = "A", secondLayer:String = "1", level:int = 1, isBack:Boolean = false, propType:int = 0, stateType:String = "") : String
      {
         var type:String = "";
         var sext:String = "";
         var equiptype:String = "";
         var back:String = "";
         var dresshat:String = "";
         var secondlayer:String = "";
         var levelt:String = "";
         var file:String = pictype + ".png";
         if(category == EquipType.ARM || category == EquipType.TEMPWEAPON)
         {
            levelt = "/" + 1;
            type = "arm/";
            if(pictype.indexOf("icon") == -1)
            {
               back = isBack ? "/1" : "/0";
            }
            return info.SITE + "image/arm/" + path + levelt + back + "/" + file;
         }
         if(category == EquipType.TITLE_CARD || category == EquipType.UNFRIGHTPROP)
         {
            return info.SITE + "image/unfrightprop/" + path + "/" + file;
         }
         if(category == EquipType.TASK)
         {
            return info.SITE + "image/task/" + path + "/icon.png";
         }
         if(category == EquipType.CHATBALL)
         {
            return info.SITE + "image/specialprop/chatBall/" + path + "/icon.png";
         }
         if(category < 10 || category == EquipType.SUITS || category == EquipType.NECKLACE || category == EquipType.TEMPARMLET || category == EquipType.TEMPRING)
         {
            if(category == EquipType.HAIR)
            {
               if(pictype.indexOf("icon") == -1)
               {
                  dresshat = "/" + dressHat;
               }
            }
            type = "equip/";
            equiptype = EquipType.TYPES[category] + "/";
            sext = sex ? "m/" : "f/";
            if(category != EquipType.ARMLET && category != EquipType.RING && category != EquipType.NECKLACE && category != EquipType.TEMPARMLET && category != EquipType.TEMPRING)
            {
               if(pictype == "icon")
               {
                  pictype = "icon_" + secondLayer;
                  secondLayer = "";
               }
               else
               {
                  secondlayer = "/" + secondLayer;
               }
            }
            else
            {
               sext = "";
            }
            file = pictype + stateType + ".png";
            return info.SITE + "image/" + type + sext + equiptype + path + secondlayer + dresshat + levelt + back + "/" + file;
         }
         if(category == EquipType.WING)
         {
            return info.SITE + "image/equip/wing/" + path + "/" + file;
         }
         if(category == EquipType.OFFHAND || category == EquipType.TEMP_OFFHAND)
         {
            return info.SITE + "image/equip/offhand/" + path + "/icon.png";
         }
         if(category == EquipType.GIFTGOODS)
         {
            return info.SITE + "image/gift/" + path + "/icon.png";
         }
         if(category == EquipType.CARDEQUIP)
         {
            return info.SITE + "image/card/" + path + "/icon.jpg";
         }
         if(category == EquipType.CARDBOX)
         {
            return info.SITE + "image/cardbox/" + path + "/icon.png";
         }
         if(category == EquipType.HEALSTONE)
         {
            return info.SITE + "image/equip/recover/" + path + "/icon.png";
         }
         if(category == EquipType.TEXP || category == EquipType.TEXP_TASK || category == EquipType.ACTIVE_TASK || category == EquipType.BADGE)
         {
            return info.SITE + "image/unfrightprop/" + path + "/icon.png";
         }
         if(category == EquipType.SEED || category == EquipType.VEGETABLE)
         {
            return info.SITE + "image/farm/Crops/" + path + "/seed.png";
         }
         if(category == EquipType.MANURE)
         {
            return info.SITE + "image/farm/Fertilizer/" + path + "/icon.png";
         }
         if(category == EquipType.FOOD || category == EquipType.PET_EGG)
         {
            return info.SITE + "image/unfrightprop/" + path + "/icon.png";
         }
         if(category == EquipType.PET_EQUIP_CLOTH)
         {
            return info.SITE + "image/petequip/cloth/" + path + "/icon.png";
         }
         if(category == EquipType.PET_EQUIP_ARM)
         {
            return info.SITE + "image/petequip/arm/" + path + "/icon.png";
         }
         if(category == EquipType.PET_EQUIP_HEAD)
         {
            return info.SITE + "image/petequip/hat/" + path + "/icon.png";
         }
         if(category == EquipType.MAGIC_STONE)
         {
            return info.SITE + "image/unfrightprop/" + path + "/" + file;
         }
         if(category == EquipType.CALL_CARD)
         {
            return info.SITE + "image/unfrightprop/" + path + "/" + file;
         }
         return info.SITE + "image/prop/" + path + "/" + file;
      }
      
      public static function soloveWingPath(path:String) : String
      {
         return info.SITE + "image/equip/wing/" + path + "/wings.swf";
      }
      
      public static function soloveSinpleLightPath(path:String) : String
      {
         return info.SITE + "image/equip/sinplelight/" + path + ".swf";
      }
      
      public static function soloveCircleLightPath(path:String) : String
      {
         return info.SITE + "image/equip/circlelight/" + path + ".swf";
      }
      
      public static function solveConsortiaIconPath(path:String) : String
      {
         return info.SITE + "image/consortiaicon/" + path + ".png";
      }
      
      public static function solveConsortiaMapPath(path:String) : String
      {
         return info.SITE + "image/consortiamap/" + path + ".png";
      }
      
      public static function solveWorldbossBuffPath() : String
      {
         return info.SITE + "image/worldboss/buff/";
      }
      
      public static function getDiceResource() : String
      {
         return info.SITE + "image/dice/";
      }
      
      public static function solveSceneCharacterLoaderPath(categoryID:Number, path:String, playerSex:Boolean = true, sex:Boolean = true, secondLayer:String = "1", direction:int = 1, sceneCharacterLoaderPath:String = "") : String
      {
         var type:String = null;
         switch(categoryID)
         {
            case EquipType.HAIR:
               type = "hair";
               return info.SITE + "image/virtual/" + (sex ? "M" : "F") + "/" + type + "/" + path + "/" + secondLayer + ".png";
            case EquipType.EFF:
               type = "eff";
               return info.SITE + "image/virtual/" + (sex ? "M" : "F") + "/" + type + "/" + path + "/" + secondLayer + ".png";
            case EquipType.FACE:
               type = "face";
               return info.SITE + "image/virtual/" + (sex ? "M" : "F") + "/" + type + "/" + path + "/" + secondLayer + ".png";
            case EquipType.CLOTH:
               type = direction == 1 ? "clothF" : (direction == 2 ? "cloth" : "clothF");
               path = sceneCharacterLoaderPath;
               if(sceneCharacterLoaderPath == "")
               {
                  path = "default";
               }
               if(StateManager.currentStateType == StateType.COLLECTION_TASK_SCENE)
               {
                  return info.SITE + "image/mounts/clothZ/" + (playerSex ? "M" : "F") + "/" + type + "/1/" + secondLayer + ".png";
               }
               return info.SITE + "image/virtual/" + (playerSex ? "M" : "F") + "/" + type + "/" + path + "/" + secondLayer + ".png";
               break;
            default:
               return info.SITE + "image/virtual/" + (sex ? "M" : "F") + "/" + type + "/" + path + "/" + secondLayer + ".png";
         }
      }
      
      public static function solveLitteGameCharacterPath(categoryID:Number, sex:Boolean, litteGameId:int, layer:int, picId:String = "") : String
      {
         var type:String = null;
         var path:String = null;
         var mainPath:String = info.SITE + "image/world/player/" + litteGameId + "/";
         switch(categoryID)
         {
            case EquipType.EFFECT:
               type = "effect";
               path = "default";
               break;
            case EquipType.FACE:
               type = "face";
               path = picId;
               return mainPath + (sex ? "M" : "F") + "/" + type + "/" + path + "/" + layer + ".png";
            case EquipType.CLOTH:
               type = "body";
               path = "default";
               return mainPath + (sex ? "M" : "F") + "/" + type + "/" + path + "/" + layer + ".png";
         }
         return mainPath + (sex ? "M" : "F") + "/" + type + "/" + path + "/" + layer + ".png";
      }
      
      public static function solveBlastPath(path:String) : String
      {
         return info.SITE + "swf/blast.swf";
      }
      
      public static function solveStyleFullPath(sex:Boolean, hair:String, body:String, face:String) : String
      {
         return info.SITE + info.STYLE_PATH + (sex ? "M" : "F") + "/" + hair + "/" + body + face + "/all.png";
      }
      
      public static function solveStyleHeadPath(sex:Boolean, type:String, style:String) : String
      {
         return info.SITE + info.STYLE_PATH + (sex ? "M" : "F") + "/" + type + "/" + style + "/head.png";
      }
      
      public static function solveStylePreviewPath(sex:Boolean, type:String, style:String) : String
      {
         return info.SITE + info.STYLE_PATH + (sex ? "M" : "F") + "/" + type + "/" + style + "/pre.png";
      }
      
      public static function solvePath(path:String) : String
      {
         return info.SITE + path;
      }
      
      public static function solveWeaponSkillSwf(skillid:int) : String
      {
         return solveSkillSwf(skillid);
      }
      
      public static function solveSkillSwf(skillid:int) : String
      {
         return info.SITE + "image/skill/" + skillid + ".swf";
      }
      
      public static function solveBlastOut(id:int) : String
      {
         return info.SITE + "image/bomb/blastOut/blastOut" + id + ".swf";
      }
      
      public static function solveBullet(id:int) : String
      {
         return info.SITE + "image/bomb/bullet/bullet" + id + ".swf";
      }
      
      public static function solveParticle() : String
      {
         return info.SITE + "image/bomb/partical.xml";
      }
      
      public static function solveShape() : String
      {
         return info.SITE + "image/bome/shape.swf";
      }
      
      public static function solveCraterBrink(id:int) : String
      {
         return info.SITE + "image/bomb/crater/" + id + "/craterBrink.png";
      }
      
      public static function solveCrater(id:int) : String
      {
         return info.SITE + "image/bomb/crater/" + id + "/crater.png";
      }
      
      public static function solveBombSwf(bombId:int) : String
      {
         return info.FLASHSITE + "bombs/" + bombId + ".swf";
      }
      
      public static function solveSoundSwf() : String
      {
         return info.FLASHSITE + "audio.swf";
      }
      
      public static function solveSoundSwf2() : String
      {
         return info.FLASHSITE + "audioii.swf";
      }
      
      public static function solveParticalXml() : String
      {
         return info.FLASHSITE + "partical.xml";
      }
      
      public static function solveShapeSwf() : String
      {
         return info.FLASHSITE + "shape.swf";
      }
      
      public static function solveCatharineSwf() : String
      {
         return info.FLASHSITE + "Catharine.swf";
      }
      
      public static function solveChurchSceneSourcePath(path:String) : String
      {
         return info.SITE + "image/church/scene/" + path + ".swf";
      }
      
      public static function solveGameLivingPath(path:String) : String
      {
         var classToPath:String = path.split(".").join("/");
         return info.SITE + "image/" + classToPath + ".swf";
      }
      
      public static function solveWeeklyImagePath(path:String) : String
      {
         return info.WEEKLY_SITE + "weekly/" + path;
      }
      
      public static function solveNewHandBuild(type:String) : String
      {
         return getUIPath() + "/img/trainer/" + type.slice(0,type.length - 3) + ".png";
      }
      
      public static function CommnuntyMicroBlog() : Boolean
      {
         return info.COMMUNITY_MICROBLOG;
      }
      
      public static function LikePersonSelected() : Boolean
      {
         return info.LIKEPERSON_SELECTED;
      }
      
      public static function CommnuntySinaSecondMicroBlog() : Boolean
      {
         return info.COMMUNITY_SINA_SECOND_MICROBLOG;
      }
      
      public static function CommunityInvite() : String
      {
         return info.COMMUNITY_INVITE_PATH;
      }
      
      public static function CommunityFriendList() : String
      {
         return info.COMMUNITY_FRIEND_LIST_PATH;
      }
      
      public static function CommunityExist() : Boolean
      {
         return info.COMMUNITY_EXIST;
      }
      
      public static function CommunityFriendInvitedSwitch() : Boolean
      {
         return info.COMMUNITY_FRIEND_INVITED_SWITCH;
      }
      
      public static function CommunityFriendInvitedOnlineSwitch() : Boolean
      {
         return info.COMMUNITY_FRIEND_INVITED_ONLINE_SWITCH;
      }
      
      public static function isVisibleExistBtn() : Boolean
      {
         return info.IS_VISIBLE_EXISTBTN;
      }
      
      public static function getSnsPath() : String
      {
         return info.SNS_PATH;
      }
      
      public static function getMicrocobolPath() : String
      {
         return info.MICROCOBOL_PATH;
      }
      
      public static function CommunityIcon() : String
      {
         return "CMFriendIcon/icon.png";
      }
      
      public static function CommunitySinaWeibo(path:String) : String
      {
         return info.SITE + path;
      }
      
      public static function solveAllowPopupFavorite() : Boolean
      {
         return info.ALLOW_POPUP_FAVORITE;
      }
      
      public static function solveFillJSCommandEnable() : Boolean
      {
         return info.FILL_JS_COMMAND_ENABLE;
      }
      
      public static function solveFillJSCommandValue() : String
      {
         return info.FILL_JS_COMMAND_VALUE;
      }
      
      public static function solveServerListIndex() : int
      {
         return info.SERVERLISTINDEX;
      }
      
      public static function solveSPAEnable() : Boolean
      {
         return info.SPA_ENABLE;
      }
      
      public static function solveCivilEnable() : Boolean
      {
         return info.CIVIL_ENABLE;
      }
      
      public static function solveChurchEnable() : Boolean
      {
         return info.CHURCH_ENABLE;
      }
      
      public static function solveWeeklyEnable() : Boolean
      {
         return info.WEEKLY_ENABLE;
      }
      
      public static function solveAchieveEnable() : Boolean
      {
         return info.ACHIEVE_ENABLE;
      }
      
      public static function solveForthEnable() : Boolean
      {
         return info.FORTH_ENABLE;
      }
      
      public static function solveStrengthMax() : int
      {
         return info.STHRENTH_MAX;
      }
      
      public static function solveUserGuildEnable() : Boolean
      {
         return info.USER_GUILD_ENABLE;
      }
      
      public static function solveFrameTimeOverTag() : int
      {
         return info.FRAME_TIME_OVER_TAG;
      }
      
      public static function solveFrameOverCount() : int
      {
         return info.FRAME_OVER_COUNT_TAG;
      }
      
      public static function solveExternalInterfacePath() : String
      {
         return info.EXTERNAL_INTERFACE_PATH;
      }
      
      public static function ExternalInterface360Path() : String
      {
         return info.EXTERNAL_INTERFACE_PATH_360;
      }
      
      public static function ExternalInterface360Enabel() : Boolean
      {
         return info.EXTERNAL_INTERFACE_ENABLE_360;
      }
      
      public static function solveExternalInterfaceEnabel() : Boolean
      {
         return info.EXTERNAL_INTERFACE_ENABLE;
      }
      
      public static function solveFeedbackEnable() : Boolean
      {
         return info.FEEDBACK_ENABLE;
      }
      
      public static function solveFeedbackTelNumber() : String
      {
         return info.FEEDBACK_TEL_NUMBER;
      }
      
      public static function solveChatFaceDisabledList() : Array
      {
         return info.CHAT_FACE_DISABLED_LIST;
      }
      
      public static function solveASTPath(name:String) : String
      {
         return info.SITE + "image/world/monster/" + name + ".png";
      }
      
      public static function solveLittleGameConfigPath(id:int) : String
      {
         return info.SITE + "image/tilemap/" + id + "/map.bin";
      }
      
      public static function solveLittleGameResPath(id:int) : String
      {
         return info.SITE + "image/world/map/" + id + "/scene.swf";
      }
      
      public static function solveLittleGameObjectPath(object:String) : String
      {
         return info.SITE + "image/world/" + object;
      }
      
      public static function solveLittleGameMapPreview(id:int) : String
      {
         return info.SITE + "image/world/map/" + id + "/preview.jpg";
      }
      
      public static function solveBadgePath(id:int) : String
      {
         return info.SITE + "image/badge/" + id + "/icon.png";
      }
      
      public static function solveLeagueRankPath(id:int) : String
      {
         return info.SITE + "image/leagueRank/" + id + "/icon.png";
      }
      
      public static function getUIPath() : String
      {
         return info.FLASHSITE + "ui/" + PathInfo.LANGUAGE;
      }
      
      public static function getBackUpUIPath() : String
      {
         return info.BACKUP_FLASHSITE;
      }
      
      public static function getUIConfigPath(module:String) : String
      {
         return getUIPath() + "/xml/" + module + ".xml";
      }
      
      public static function getLanguagePath() : String
      {
         return getUIPath() + "/" + "language.png";
      }
      
      public static function getMovingNotificationPath() : String
      {
         return getUIPath() + "/" + "movingNotification.txt";
      }
      
      public static function getLevelRewardPath() : String
      {
         return getUIPath() + "/" + "levelReward.xml";
      }
      
      public static function getExpressionPath() : String
      {
         return getUIPath() + "/swf/" + "expression.swf";
      }
      
      public static function getZhanPath() : String
      {
         return getUIPath() + "/" + "zhanCode.txt";
      }
      
      public static function getCardXMLPath(xmlName:String) : String
      {
         return xmlName;
      }
      
      public static function getFightAchieveEnable() : Boolean
      {
         return true;
      }
      
      public static function getFightLibEanble() : Boolean
      {
         return info.FIGHTLIB_ENABLE;
      }
      
      public static function getMonsterPath() : String
      {
         return "monster.swf";
      }
      
      public static function get FLASHSITE() : String
      {
         return info != null ? info.FLASHSITE : null;
      }
      
      public static function get TRAINER_STANDALONE() : Boolean
      {
         return info != null && info.TRAINER_STANDALONE;
      }
      
      public static function get isStatistics() : Boolean
      {
         return info.STATISTICS;
      }
      
      public static function get DISABLE_TASK_ID() : Array
      {
         var arr:Array = new Array();
         if(info == null)
         {
            return arr;
         }
         return info.DISABLE_TASK_ID.split(",");
      }
      
      public static function get LittleGameMinLv() : int
      {
         return info.LITTLEGAMEMINLV;
      }
      
      public static function solvePetGameAssetUrl(asseturl:String) : String
      {
         return info.SITE + "image/gameasset/" + asseturl + ".swf";
      }
      
      public static function solvePetFarmAssetUrl(asseturl:String) : String
      {
         return info.SITE + "image/" + asseturl + ".swf";
      }
      
      public static function solveSkillPicUrl(pic:String) : String
      {
         return info.SITE + "image/petskill/" + pic + "/icon.png";
      }
      
      public static function solvePetSkillEffect(effect:String) : String
      {
         return info.SITE + "image/skilleffect/" + effect + ".swf";
      }
      
      public static function solvePetBuff(buff:String) : String
      {
         return info.SITE + "image/buff/" + buff + "/icon.png";
      }
      
      public static function solvePetIconUrl(folder:String) : String
      {
         return info.SITE + "image/pet/" + folder + ".png";
      }
      
      public static function solveGradeNotificationPath(grade:int) : String
      {
         return info.GRADE_NOTIFICATION[grade.toString()];
      }
      
      public static function solveWorldBossMapSourcePath(path:String) : String
      {
         return getUIPath() + "/" + "Map02.swf";
      }
      
      public static function callLoginInterface() : String
      {
         return info.CALL_LOGIN_INTERFAECE;
      }
      
      public static function userActionNotice() : String
      {
         return info.USER_ACTION_NOTICE;
      }
      
      public static function solveRandomChannel() : Boolean
      {
         return info.RANDOM_CHANNEL;
      }
      
      public static function solveCrossBuggleEable() : Boolean
      {
         return info.CROSSBUGGLE;
      }
      
      public static function get OVERSEAS_COMMUNITY_TYPE() : int
      {
         return info.OVERSEAS_COMMUNITY_TYPE;
      }
      
      public static function get OVERSEAS_COMMUNITY_PATH() : String
      {
         return info.OVERSEAS_COMMUNITY_PATH;
      }
      
      public static function get OVERSEAS_COMMUNITY_CALLJS() : String
      {
         return info.OVERSEAS_COMMUNITY_CALLJS;
      }
      
      public static function vietnamCommunityInterfacePath(method:String) : String
      {
         return info.OVERSEAS_COMMUNITY_PATH.concat(method);
      }
      
      public static function isVisibleShareBtn() : Boolean
      {
         return info.IS_VISIBLE_SHAREBTN;
      }
      
      public static function get hotSpringContinue() : Boolean
      {
         return info.HOTSPRING_CONTINUE;
      }
      
      public static function get solveDungeonOpenList() : Array
      {
         return info.DUNGEON_OPENLIST;
      }
      
      public static function get suitEnable() : Boolean
      {
         return info.SUIT_ENABLE;
      }
      
      public static function get advancedEnable() : Boolean
      {
         return info.ADVANCED_ENABLE;
      }
      
      public static function get footballEnable() : Boolean
      {
         return info.FOOTBALL_ENABLE;
      }
      
      public static function get epicLevelEnable() : Boolean
      {
         return info.EPICLEVEL_ENABLE;
      }
      
      public static function get exaltEnable() : Boolean
      {
         return info.EXALT_ENABLE;
      }
      
      public static function get eatPetsEnable() : Boolean
      {
         return info.PETS_EAT;
      }
      
      public static function get pkEnable() : Boolean
      {
         return info.PK_BTN;
      }
      
      public static function get kingblessEnable() : Boolean
      {
         return info.KINGBLESS_ENABLE;
      }
      
      public static function get questTrusteeshipEnable() : Boolean
      {
         return info.QUEST_TRUSTEESHIP_ENABLE;
      }
      
      public static function solveTrusteeshipEnable() : Boolean
      {
         return info.Trusteeship_ENABLE;
      }
      
      public static function get solveWarriorsFamSwitch() : Boolean
      {
         return info.WARRIORS_FAM_ENABLE;
      }
      
      public static function get solveGemstoneSwitch() : Boolean
      {
         return info.GEMSTONE_ENABLE;
      }
      
      public static function get treasureSwitch() : Boolean
      {
         return info.TREASURE;
      }
      
      public static function get treasureHelpTimes() : int
      {
         return info.TREASUREHELPTIMES;
      }
      
      public static function get crossServerChatSwitch() : Boolean
      {
         return info.CROSS_CHAT_SERVER;
      }
      
      public static function get checkDeskKillSwitch() : Boolean
      {
         return info.CHECKDESK_KILL;
      }
      
      public static function get pointEnable() : Boolean
      {
         return info.POINT_ENABLE;
      }
      
      public static function get progressEnable() : Boolean
      {
         return info.PROGRESS_ENABLE;
      }
      
      public static function get dottelineEnable() : Boolean
      {
         return info.DOTTELINE_ENABLE;
      }
      
      public static function callBackInterfacePath() : String
      {
         return info.CALLBACK_INTERFACE_PATH;
      }
      
      public static function callBackEnable() : Boolean
      {
         return info.CALLBACK_INTERFACE_ENABLE;
      }
      
      public static function getPlayerRegressNotificationPath() : String
      {
         return getUIPath() + "/" + "playerRegressNotification.txt";
      }
      
      public static function getAreaNameInfoPath() : String
      {
         return getUIPath() + "/" + "AreaNameInfo.xml";
      }
      
      public static function smallMapEnable() : Boolean
      {
         return info.SMALLMAP_ENABLE;
      }
      
      public static function smallMapMeterEnable() : Boolean
      {
         return info.SMALLMAP_METERENABLE;
      }
      
      public static function smallMapBorderEnable() : Boolean
      {
         return info.SMALLMAP_BORDERENABLE;
      }
      
      public static function smallMapAlpha() : Boolean
      {
         return info.SMALLMAP_BORDERALPHA;
      }
      
      public static function solveChristmasMonsterPath(pPath:String) : String
      {
         return info.SITE + "image/scene/christmas/monsters/" + pPath + ".swf";
      }
      
      public static function get GodSyahEnable() : Boolean
      {
         return info.GODSYAH_ENABLE;
      }
      
      public static function solveCollectionTaskSceneSourcePath(path:String) : String
      {
         return info.SITE + "image/collectiontask/" + path + ".swf";
      }
      
      public static function get isSendRecordUserVersion() : Boolean
      {
         if(info.IS_SEND_RECORDUSERVERSION)
         {
            return info.IS_SEND_RECORDUSERVERSION;
         }
         return false;
      }
      
      public static function get isSendFlashInfo() : Boolean
      {
         if(info.IS_SEND_FLASHINFO)
         {
            return info.IS_SEND_FLASHINFO;
         }
         return false;
      }
      
      public static function get flashP2PEbable() : Boolean
      {
         return info.FLASH_P2P_EBABLE;
      }
      
      public static function get flashP2PKey() : String
      {
         return info.FLASH_P2P_KEY;
      }
      
      public static function get flashP2PCirrusUrl() : String
      {
         return info.FLASH_P2P_CIRRUS_URL;
      }
      
      public static function phoneBandEnable() : Boolean
      {
         return info.PHONEBAND;
      }
      
      public static function get onekeyDoneSwitch() : Boolean
      {
         return info.ONEKEY_DONE;
      }
      
      public static function solveFillFbapp() : String
      {
         info.FILL_PATH_FBAPP = info.FILL_PATH_FBAPP.replace("{uid}",PlayerManager.Instance.Self.ID);
         return info.FILL_PATH_FBAPP;
      }
      
      public static function get gameStatsEnable() : Boolean
      {
         return info.GAME_STATS_ENABLE;
      }
      
      public static function get add_public_tip() : Boolean
      {
         return info.ADD_PUBLIC_TIP;
      }
      
      public static function solveBoguAdventurePath() : String
      {
         return info.SITE + "image/equip/f/suits/suits100/1/game.png";
      }
      
      public static function get magicstoneDiscountEnable() : Boolean
      {
         return info.MAGICSTONE_DISCOUNT;
      }
      
      public static function petsFormPath(path:String, id:int) : String
      {
         return info.SITE + "image/pet/" + path + "/icon" + id + ".png";
      }
      
      public static function petsAnimationPath(path:String) : String
      {
         return info.SITE + "image/game/living/" + path + ".swf";
      }
      
      public static function get vipDiscountEnable() : Boolean
      {
         return info.VIP_DISCOUNT;
      }
      
      public static function get fight_time() : int
      {
         return info.FIGHT_TIME;
      }
      
      public static function get kingFightEnable() : Boolean
      {
         return info.KINGFIGNT;
      }
	  
	  public static function getWeatherUrl(param1:int) : String
	  {
		  return info.SITE + "image/weather/" + param1 + "/1.swf";
	  }
   }
}

