package ddt.events
{
	import flash.events.Event;
	import road7th.comm.PackageIn;
	
	public class CrazyTankSocketEvent extends Event
	{
		
		public static const POPUP_LEAGUESTART_NOTICE:String = "popup_leagueStart_notice";
		
		public static const LEFT_GUN_ROULETTE:String = "left_gun_roulette";
		
		public static const LEFT_GUN_ROULETTE_START:String = "left_gun_roulette_start";
		
		public static const USER_LUCKYNUM:String = "userluckynum";
		
		public static const LITTLEGAME_ACTIVED:String = "littlegameactived";
		
		public static const BAG_LOCKED:String = "bagLocked";
		
		public static const CONSORTIA_EQUIP_CONTROL:String = "consortiaEquipControl";
		
		public static const PLAYER_START_MOVE:String = "playerStartMove";
		
		public static const PLAYER_STOP_MOVE:String = "playerStopMove";
		
		public static const PLAY_FINISH:String = "playeFinished";
		
		public static const PLAYER_MOVE:String = "playerMove";
		
		public static const BOMB_DIE:String = "bombDie";
		
		public static const DAILY_AWARD:String = "dailyAward";
		
		public static const DIRECTION_CHANGED:String = "playerDirection";
		
		public static const CHANGE_BALL:String = "changeBall";
		
		public static const PLAYER_GUN_ANGLE:String = "playerGunAngle";
		
		public static const PLAYER_SHOOT:String = "playerShoot";
		
		public static const PLAYER_SHOOT_TAG:String = "playerShootTag";
		
		public static const PLAYER_BEAT:String = "playerBeat";
		
		public static const BOX_DISAPPEAR:String = "boxdisappear";
		
		public static const PICK_BOX:String = "PickBox";
		
		public static const PLAYER_CHANGE:String = "playerChange";
		
		public static const PLAYER_BLOOD:String = "playerBlood";
		
		public static const PLAYER_FROST:String = "playerFrost";
		
		public static const PLAYER_INVINCIBLY:String = "playerInvincibly";
		
		public static const PLAYER_HIDE:String = "playerHide";
		
		public static const PLAYER_CARRY:String = "playerCarry";
		
		public static const PLAYER_BECKON:String = "playerBeckon";
		
		public static const PLAYER_NONOLE:String = "playerNoNole";
		
		public static const PLAYER_PROPERTY:String = "playerProperty";
		
		public static const CHANGE_STATE:String = "changeState";
		
		public static const PLAYER_VANE:String = "playerVane";
		
		public static const PLAYER_APK:String = "playerAPK";
		
		public static const PLAYER_PICK_BOX:String = "playerPick";
		
		public static const PLAYER_FIGHT_PROP:String = "playerFightProp";
		
		public static const PLAYER_STUNT:String = "playerStunt";
		
		public static const PLAYER_PROP:String = "playerProp";
		
		public static const PLAYER_DANDER:String = "playerDander";
		
		public static const REDUCE_DANDER:String = "reduceDander";
		
		public static const LOAD:String = "load";
		
		public static const PLAYER_ADDATTACK:String = "playerAddAttack";
		
		public static const PLAYER_ADDBAL:String = "playerAddBall";
		
		public static const SHOOTSTRAIGHT:String = "shootStaight";
		
		public static const SUICIDE:String = "suicide";
		
		public static const GAME_REVIVE:String = "gameRevive";
		
		public static const FIGHT_STATUS:String = "gameFightStatus";
		
		public static const SKIPNEXT:String = "gameSkipNext";
		
		public static const CLEAR_DEBUFF:String = "gameClearDebuff";
		
		public static const USE_PET_SKILL:String = "usePetSkill";
		
		public static const PET_BEAT:String = "petBeat";
		
		public static const PET_SKILL_CD:String = "petSkillCD";
		
		public static const WISHOFDD:String = "wishofdd";
		
		public static const PET_BUFF:String = "petBuff";
		
		public static const PING:String = "ping";
		
		public static const NETWORK:String = "netWork";
		
		public static const GAME_TAKE_TEMP:String = "gameTakeTemp";
		
		public static const CONNECT_SUCCESS:String = "connectSuccess";
		
		public static const LOGIN:String = "login";
		
		public static const GAME_ROOM_CREATE:String = "gameRoomCreate";
		
		public static const GAME_ROOMLIST_UPDATE:String = "gameRoomListUpdate";
		
		public static const ROOMLIST_PASS:String = "RoomListPass";
		
		public static const SCENE_ADD_USER:String = "sceneAddUser";
		
		public static const GAME_PLAYER_ENTER:String = "gamePlayerEnter";
		
		public static const SINGLE_ROOM_BEGIN:String = "SINGLE_ROOM_BEGIN";
		
		public static const KIT_USER:String = "kitUser";
		
		public static const UPDATE_PRIVATE_INFO:String = "updateAllSorce";
		
		public static const QQTIPS_GET_INFO:String = "QQTIPSGETINFO";
		
		public static const EDICTUM_GET_VERSION:String = "edictum_get_version";
		
		public static const GAME_ROOM_UPDATE_PLACE:String = "gameRoomOpen";
		
		public static const GAME_ROOM_KICK:String = "gameRoomKick";
		
		public static const GAME_PLAYER_EXIT:String = "GamePlayerExit";
		
		public static const GAME_WAIT_RECV:String = "recvGameWait";
		
		public static const GAME_WAIT_FAILED:String = "GameWaitFailed";
		
		public static const GAME_AWIT_CANCEL:String = "GameWaitCancel";
		
		public static const GMAE_STYLE_RECV:String = "GameStyleRecv";
		
		public static const GAME_ROOM_LOGIN:String = "gameLogin";
		
		public static const GAME_TEAM:String = "gameTeam";
		
		public static const GAME_PLAYER_STATE_CHANGE:String = "playerState";
		
		public static const GAME_ROOM_FULL:String = "gameRoomFull";
		
		public static const FAST_INVITE_CALL:String = "fastInviteCall";
		
		public static const GAME_ENERGY_NOT_ENOUGH:String = "gameEnergyNotEnough";
		
		public static const UPDATE_BUFF_LEVEL:String = "UPDATE_BUFF_LEVEL";
		
		public static const GAME_CREATE:String = "gameCreate";
		
		public static const GAME_START:String = "gameStart";
		
		public static const GAME_LOAD:String = "gameLoad";
		
		public static const GAME_MISSION_INFO:String = "gameMissionInfo";
		
		public static const SCENE_CHANNEL_CHANGE:String = "sceneChannelChange";
		
		public static const SCENE_CHAT:String = "scenechat";
		
		public static const SCENE_FACE:String = "sceneface";
		
		public static const SCENE_REMOVE_USER:String = "sceneRemoveUser";
		
		public static const DELETE_GOODS:String = "deletegoods";
		
		public static const BUY_GOODS:String = "buygoods";
		
		public static const BUY_BEAD:String = "buybead";
		
		public static const CHANGE_GOODS_PLACE:String = "changegoodsplace";
		
		public static const BREAK_GOODS:String = "breakgoods";
		
		public static const CHAIN_EQUIP:String = "chainequip";
		
		public static const UNCHAIN_EQUIP:String = "unchainequip";
		
		public static const SELL_GOODS:String = "sellgoods";
		
		public static const REPAIR_GOODS:String = "repairGoods";
		
		public static const SEND_EMAIL:String = "sendEmail";
		
		public static const DELETE_MAIL:String = "deleteMail";
		
		public static const GET_MAIL_ATTACHMENT:String = "getMailAttachment";
		
		public static const MAIL_CANCEL:String = "mailCancel";
		
		public static const MAIL_RESPONSE:String = "mailResponse";
		
		public static const CONSORTION_MAIL:String = "consortionMail";
		
		public static const GRID_PROP:String = "gridProp";
		
		public static const GRID_GOODS:String = "gridgoods";
		
		public static const AREA_INFO_UPDATE:String = "AreaInfoUpdate";
		
		public static const UPDATE_COUPONS:String = "updateCoupons";
		
		public static const UPDATE_OFFER:String = "updateoffer";
		
		public static const ITEM_STORE:String = "itemStore";
		
		public static const CHECK_CODE:String = "checkCode";
		
		public static const GET_DYNAMIC:String = "get_dynamic";
		
		public static const CONSORTIA_RESPONSE:String = "consortiaresponse";
		
		public static const CONSORTIA_USER_GRADE_UPDATE:String = "consortiagradeuodateevent";
		
		public static const CONSORTIA_CREATE:String = "consortiacreateevent";
		
		public static const CONSORTIA_TRYIN:String = "consortiatryinevent";
		
		public static const CONSORTIA_TRYIN_DEL:String = "consortiatryindelevent";
		
		public static const CONSORTIA_PLACARD_UPDATE:String = "consortiaPlacardUpdate";
		
		public static const CONSORTIA_DESCRIPTION_UPDATE:String = "consortiadescriptionupdate";
		
		public static const CONSORTIA_DISBAND:String = "consortiadisbandevent";
		
		public static const CONSORTIA_APPLY_STATE:String = "consortiaapplystateevent";
		
		public static const CONSORTIA_INVITE_PASS:String = "consortiainvatepassevent";
		
		public static const CONSORTIA_INVITE:String = "consortiainvateevent";
		
		public static const CONSORTIA_RENEGADE:String = "consortiarenegadeevent";
		
		public static const CONSORTIA_DUTY_DELETE:String = "consortiadutydeleteevent";
		
		public static const CONSORTIA_DUTY_UPDATE:String = "consortiadutyupdateevent";
		
		public static const CONSORTIA_BANCHAT_UPDATE:String = "consortiabanchatupdateevent";
		
		public static const CONSORTIA_USER_REMARK_UPDATE:String = "consortiauserremarkupdateevent";
		
		public static const CONSORTIA_CHAT:String = "consortiachatevent";
		
		public static const CONSORTIA_ALLY_APPLY_UPDATE:String = "consortiaAllyAppleUpdate";
		
		public static const CONSORTIA_ALLY_UPDATE:String = "consortiaallyupdate";
		
		public static const CONSORTIA_ALLY_APPLY_DELETE:String = "consortiaallyapplydelete";
		
		public static const CONSORTIA_ALLY_APPLY_ADD:String = "consortiaallyapplyadd";
		
		public static const CONSORTIA_LEVEL_UP:String = "consortialevelup";
		
		public static const CONSORTIA_CHAIRMAN_CHAHGE:String = "consortiachairmanchange";
		
		public static const CONSORTIA_TRYIN_PASS:String = "consortiatryinpass";
		
		public static const CONSORTIA_RICHES_OFFER:String = "consortiaRichesOffer";
		
		public static const CONSORTIA_MAIL_MESSAGE:String = "consortiaMailMessage";
		
		public static const BUY_BADGE:String = "buyBadge";
		
		public static const CONSORTIA_BOSS_OPEN_CLOSE:String = "consortia_boss_open_close";
		
		public static const GAME_OVER:String = "gameOver";
		
		public static const MISSION_OVE:String = "missionOver";
		
		public static const MISSION_COMPLETE:String = "missionOver";
		
		public static const GAME_ALL_MISSION_OVER:String = "gameAllMissionOver";
		
		public static const GAME_TAKE_OUT:String = "gameTakeOut";
		
		public static const GAME_ROOM_SETUP_CHANGE:String = "gameRoomSetUp";
		
		public static const EQUIP_CHANGE:String = "equipchange";
		
		public static const MARRYINFO_GET:String = "marryinfoget";
		
		public static const AMARRYINFO_REFRESH:String = "amarryinforefresh";
		
		public static const GAME_OPEN_SELECT_LEADER:String = "gameOpenSelectLeader";
		
		public static const GAME_WANNA_LEADER:String = "gameWannaLeader";
		
		public static const GAME_CAPTAIN_CHOICE:String = "gamecaptionchoice";
		
		public static const GAME_CAPTAIN_AFFIRM:String = "gamecaptainaffirm";
		
		public static const SCENE_USERS_LIST:String = "sceneuserlist";
		
		public static const GAME_INVITE:String = "gameinvite";
		
		public static const UPDATE_PLAYER_INFO:String = "updatestyle";
		
		public static const TEMP_STYLE:String = "tempStyle";
		
		public static const S_BUGLE:String = "sbugle";
		
		public static const B_BUGLE:String = "bbugle";
		
		public static const C_BUGLE:String = "cbugle";
		
		public static const CHAT_PERSONAL:String = "chatpersonal";
		
		public static const AREA_CHAT:String = "areaChat";
		
		public static const FRIEND_ADD:String = "friendAdd";
		
		public static const FRIEND_REMOVE:String = "friendremove";
		
		public static const FRIEND_UPDATE:String = "friendupdate";
		
		public static const FRIEND_STATE:String = "friendstate";
		
		public static const ITEM_COMPOSE:String = "itemCompose";
		
		public static const ITEM_ADVANCE:String = "itemAdvance";
		
		public static const ITEM_STRENGTH:String = "itemstrength";
		
		public static const ITEM_TRANSFER:String = "itemtransfer";
		
		public static const DEFY_AFFICHE:String = "DefyAffiche";
		
		public static const ITEM_FUSION:String = "itemfusion";
		
		public static const ITEM_FUSION_PREVIEW:String = "itemfusionpreview";
		
		public static const ITEM_REFINERY_PREVIEW:String = "itemRefineryPreview";
		
		public static const ITEM_REFINERY:String = "itemRefinery";
		
		public static const ITEM_EMBED:String = "itemEmbed";
		
		public static const OPEN_FIVE_SIX_HOLE_EMEBED:String = "open_five_six_hole_embed";
		
		public static const CLEAR_STORE_BAG:String = "clearStoreBag";
		
		public static const SYS_CHAT_DATA:String = "syschatdata";
		
		public static const SYS_NOTICE:String = "sysnotice";
		
		public static const ITEM_CONTINUE:String = "itemContinue";
		
		public static const ITEM_EQUIP:String = "itemEquip";
		
		public static const FRIEND_RESPONSE:String = "friendresponse";
		
		public static const ITEM_OBTAIN:String = "itemObtain";
		
		public static const SYS_DATE:String = "sysDate";
		
		public static const QUEST_MANU_GET:String = "quiestManuGet";
		
		public static const QUEST_UPDATE:String = "quiestUpdate";
		
		public static const QUEST_OBTAIN:String = "quiestObtain";
		
		public static const QUEST_CHECK:String = "quiestCheck";
		
		public static const QUEST_FINISH:String = "quiestFinish";
		
		public static const QUEST_ONEKEYFINISH:String = "questOneKeyFinsh";
		
		public static const AUCTION_DELETE:String = "auctionDelete";
		
		public static const AUCTION_UPDATE:String = "auctionUpdate";
		
		public static const AUCTION_ADD:String = "auctionAdd";
		
		public static const AUCTION_REFRESH:String = "auctionRefresh";
		
		public static const CID_CHECK:String = "CIDCheck";
		
		public static const ENTHRALL_LIGHT:String = "CIDInfo";
		
		public static const BUFF_INFO:String = "buffInfo";
		
		public static const BUFF_OBTAIN:String = "buffObtain";
		
		public static const BUFF_ADD:String = "buffAdd";
		
		public static const BUFF_UPDATE:String = "buffUpdate";
		
		public static const USE_COLOR_CARD:String = "useColorCard";
		
		public static const USE_COLOR_SHELL:String = "useColorShell";
		
		public static const MARRY_ROOM_CREATE:String = "marry room create";
		
		public static const MARRY_ROOM_LOGIN:String = "marry room login";
		
		public static const MARRY_SCENE_LOGIN:String = "marry scene login";
		
		public static const MARRY_SCENE_CHANGE:String = "marry scene change";
		
		public static const PLAYER_ENTER_MARRY_ROOM:String = "player enter room";
		
		public static const PLAYER_EXIT_MARRY_ROOM:String = "exit marry room";
		
		public static const MARRY_APPLY:String = "marray apply";
		
		public static const MARRY_APPLY_REPLY:String = "marry apply reply";
		
		public static const DIVORCE_APPLY:String = "divorce apply";
		
		public static const MARRY_STATUS:String = "marry status";
		
		public static const MOVE:String = "church move";
		
		public static const HYMENEAL:String = "hymeneal";
		
		public static const CONTINUATION:String = "church continuation";
		
		public static const INVITE:String = "church invite";
		
		public static const LARGESS:String = "church largess";
		
		public static const USEFIRECRACKERS:String = "use firecrackers";
		
		public static const KICK:String = "church kick";
		
		public static const FORBID:String = "church forbid";
		
		public static const MARRY_ROOM_STATE:String = "marry room state";
		
		public static const HYMENEAL_STOP:String = "hymeneal stop";
		
		public static const MARRY_ROOM_DISPOSE:String = "marry room dispose";
		
		public static const MARRY_ROOM_UPDATE:String = "marry room update";
		
		public static const MARRYPROP_GET:String = "marryprop get";
		
		public static const GUNSALUTE:String = "Gun Salute";
		
		public static const MATE_ONLINE_TIME:String = "Mate_Online_Time";
		
		public static const MARRYROOMSENDGIFT:String = "marryRoomSendGift";
		
		public static const MARRYINFO_UPDATE:String = "marryinfo update";
		
		public static const MARRYINFO_ADD:String = "marryInfo add";
		
		public static const PLAY_MOVIE:String = "playMovie";
		
		public static const ADD_LIVING:String = "addLiving";
		
		public static const ADD_MAP_THINGS:String = "addMapThing";
		
		public static const LIVING_MOVETO:String = "livingMoveTo";
		
		public static const LIVING_FALLING:String = "livingFalling";
		
		public static const LIVING_JUMP:String = "livingJump";
		
		public static const LIVING_BEAT:String = "livingBeat";
		
		public static const LIVING_SAY:String = "livingSay";
		
		public static const LIVING_RANGEATTACKING:String = "livingRangeAttacking";
		
		public static const BARRIER_INFO:String = "barrierInfo";
		
		public static const ADD_MAP_THING:String = "addMapThing";
		
		public static const UPDATE_BOARD_STATE:String = "updateBoardState";
		
		public static const GAME_MISSION_START:String = "gameMissionStart";
		
		public static const GAME_MISSION_PREPARE:String = "gameMissionPrepare";
		
		public static const SHOW_CARDS:String = "showCard";
		
		public static const UPDATE_BUFF:String = "updateBuff";
		
		public static const GEM_GLOW:String = "gemGlow";
		
		public static const LINKGOODSINFO_GET:String = "linkGoodsInfo";
		
		public static const FOCUS_ON_OBJECT:String = "focusOnObject";
		
		public static const GAME_ROOM_INFO:String = "gameRoomInfo";
		
		public static const ADD_TIP_LAYER:String = "addTipLayer";
		
		public static const PLAY_INFO_IN_GAME:String = "playInfoInGame";
		
		public static const PAYMENT_TAKE_CARD:String = "playmentTakeCard";
		
		public static const INSUFFICIENT_MONEY:String = "insufficientMoney";
		
		public static const GAME_MISSION_TRY_AGAIN:String = "gameMissionTryAgain";
		
		public static const IS_LAST_MISSION:String = "islastMission";
		
		public static const PASSED_WARRIORSARENA_10:String = "passed_warriorsarena_10";
		
		public static const LAST_MISSION_FOR_WARRIORSARENA:String = "warriorsarenaLastMission";
		
		public static const No_WARRIORSARENA_TICKET:String = "no_Warriorsarena_ticket";
		
		public static const GET_ITEM_MESS:String = "getItemMess";
		
		public static const USER_ANSWER:String = "userAnswer";
		
		public static const PLAY_SOUND:String = "playSound";
		
		public static const LOAD_RESOURCE:String = "loadResource";
		
		public static const PLAY_ASIDE:String = "playWordTip";
		
		public static const FORBID_DRAG:String = "forbidDrag";
		
		public static const TOP_LAYER:String = "topLayer";
		
		public static const GOODS_PRESENT:String = "goodsPresents";
		
		public static const GOODS_COUNT:String = "goodsCount";
		
		public static const CONTROL_BGM:String = "controlBGM";
		
		public static const FIGHT_LIB_INFO_CHANGE:String = "fightLibInfoChange";
		
		public static const USE_DEPUTY_WEAPON:String = "Use_Deputy_Weapon";
		
		public static const POPUP_QUESTION_FRAME:String = "popupQuestionFrame";
		
		public static const SHOW_PASS_STORY_BTN:String = "showPassStoryBtn";
		
		public static const LIVING_BOLTMOVE:String = "livingBoltmove";
		
		public static const CHANGE_TARGET:String = "changeTarget";
		
		public static const LIVING_SHOW_BLOOD:String = "livingShowBlood";
		
		public static const ACTION_MAPPING:String = "actionMapping";
		
		public static const FIGHT_ACHIEVEMENT:String = "fightAchievement";
		
		public static const APPLYSKILL:String = "applySkill";
		
		public static const REMOVESKILL:String = "removeSkill";
		
		public static const CHANGEMAXFORCE:String = "changedMaxForce";
		
		public static const HOTSPRING_ROOM_CREATE:String = "hotSpringRoomCreate";
		
		public static const HOTSPRING_ROOM_ADD_OR_UPDATE:String = "hotSpringListRoomAddOrUpdate";
		
		public static const HOTSPRING_ROOM_REMOVE:String = "hotSpringRoomRemove";
		
		public static const HOTSPRING_ROOM_LIST_GET:String = "hotSpringRoomListGet";
		
		public static const HOTSPRING_ROOM_ENTER:String = "hotSpringRoomEnter";
		
		public static const HOTSPRING_ROOM_PLAYER_ADD:String = "hotSpringRoomPlayerAdd";
		
		public static const HOTSPRING_ROOM_PLAYER_REMOVE:String = "hotSpringRoomPlayerRemove";
		
		public static const CONTINU_BY_MONEY_SUCCESS:String = "hotSpringRoomPlayerContinuByMoneySucess";
		
		public static const HOTSPRING_ROOM_TIME_END:String = "hotSpringRoomTimeEnd";
		
		public static const HOTSPRING_ROOM_CLICKFLOWER_EGG:String = "HOTSPRING_ROOM_CLICKFLOWER_EGG";
		
		public static const HOTSPRING_ROOM_PLAYER_REMOVE_NOTICE:String = "hotSpringRoomPlayerRemoveNotice";
		
		public static const HOTSPRING_ROOM_PLAYER_TARGET_POINT:String = "hotSpringRoomPlayerTargetPoint";
		
		public static const HOTSPRING_ROOM_RENEWAL_FEE:String = "hotSpringRoomRenewalFee";
		
		public static const HOTSPRING_ROOM_INVITE:String = "hotSpringRoomInvite";
		
		public static const HOTSPRING_ROOM_TIME_UPDATE:String = "hotSpringRoomTimeUpdate";
		
		public static const HOTSPRING_ROOM_ENTER_CONFIRM:String = "hotSpringRoomEnterConfirm";
		
		public static const HOTSPRING_ROOM_PLAYER_CONTINUE:String = "hotSpringRoomPlayerContinue";
		
		public static const GET_TIME_BOX:String = "getTimeBox";
		
		public static const GET_TIME_BOX_INFO:String = "getTimeBoxInfo";
		
		public static const ACHIEVEMENT_UPDATE:String = "achievementUpdate";
		
		public static const ACHIEVEMENT_FINISH:String = "achievementFinish";
		
		public static const ACHIEVEMENT_INIT:String = "achievementInit";
		
		public static const ACHIEVEMENTDATA_INIT:String = "achievementDateInit";
		
		public static const USER_RANK:String = "userRank";
		
		public static const FIGHT_NPC:String = "fightNpc";
		
		public static const FEEDBACK_REPLY:String = "feedbackReply";
		
		public static const LOTTERY_ALTERNATE_LIST:String = "lottery_alternate_list";
		
		public static const LOTTERY_GET_ITEM:String = "lottery_get_item";
		
		public static const LOTTERY_OPNE:String = "lottery_open";
		
		public static const CADDY_GET_AWARDS:String = "caddy_get_awards";
		
		public static const CADDY_GET_CONVERTED:String = "caddy_get_converted";
		
		public static const CADDY_GET_EXCHANGEALL:String = "caddy_get_exchange";
		
		public static const CADDY_GET_BADLUCK:String = "caddy_get_badLuck";
		
		public static const OFFERPACK_COMPLETE:String = "offer_pack_complete";
		
		public static const LOOKUP_EFFORT:String = "lookupEffort";
		
		public static const ANSWERBOX_QUESTIN:String = "AnswerBoxQuestion";
		
		public static const VIP_IS_OPENED:String = "vipIsOpened";
		
		public static const VIP_REWARD_IS_TAKED:String = "vipRewardIsTaked";
		
		public static const ITEM_OPENUP:String = "ITEM_OPENUP";
		
		public static const USER_GET_GIFTS:String = "getGifts";
		
		public static const USER_SEND_GIFTS:String = "sendGift";
		
		public static const USER_UPDATE_GIFT:String = "upDateGift";
		
		public static const USER_RELOAD_GIFT:String = "userReloadGift";
		
		public static const WEEKLY_CLICK_CNT:String = "weeklyClickCnt";
		
		public static const ACTIVE_PULLDOWN:String = "ACTIVE_PULLDOWN";
		
		public static const APPRENTICE_SYSTEM_ANSWER:String = "ApprenticeSystemAnswer";
		
		public static const CARDS_DATA:String = "cards_data";
		
		public static const CARD_RESET:String = "card_reset";
		
		public static const GET_CARD:String = "get_card";
		
		public static const CARDS_SOUL:String = "cards_soul";
		
		public static const CARDS_PLAYER_DATA:String = "cards_player_data";
		
		public static const CHAT_FILTERING_FRIENDS_SHARE:String = "chatFilteringFriendsShare";
		
		public static const POLL_CANDIDATE:String = "pollCandidate";
		
		public static const SKILL_SOCKET:String = "skillSocket";
		
		public static const CONSORTIA_TASK_RELEASE:String = "consortia_task_release";
		
		public static const ONS_EQUIP:String = "onsItemEquip";
		
		public static const DAILYRECORD:String = "dailyRecord";
		
		public static const GAMESYSMESSAGE:String = "gamesysmessage";
		
		public static const WINDPIC:String = "windPic";
		
		public static const SAME_CITY_FRIEND:String = "sameCityFriend";
		
		public static const ADD_CUSTOM_FRIENDS:String = "addCustomFriends";
		
		public static const ONE_ON_ONE_TALK:String = "oneOnoneTalk";
		
		public static const TEXP:String = "texp";
		
		public static const USERREGISTEROK:String = "userRegisterOk";
		
		public static const ELITE_MATCH_TYPE:String = "eliteMatchType";
		
		public static const ELITE_MATCH_RANK_START:String = "eliteMatchRankStart";
		
		public static const ELITE_MATCH_PLAYER_RANK:String = "eliteMatchPlayerRank";
		
		public static const ELITE_MATCH_RANK_DETAIL:String = "eliteMatchRankDetail";
		
		public static const LIVING_CHAGEANGLE:String = "LivingChangeAngele";
		
		public static const WISHBEADEQUIP:String = "wishbeadequip";
		
		public static const REALlTIMES_ITEMS_BY_DISCOUNT:String = "RealTimesItemsByDisCount";
		
		public static const UPDATE_PET:String = "updatePet";
		
		public static const MOVE_PETBAG:String = "movePetBag";
		
		public static const FEED_PET:String = "feedPet";
		
		public static const EQUIP_PET_SKILL:String = "equipPetSkill";
		
		public static const RENAME_PET:String = "renamePet";
		
		public static const RELEASE_PET:String = "releasePet";
		
		public static const ADOPT_PET:String = "adoptPet";
		
		public static const REFRESH_PET:String = "refreshPet";
		
		public static const ADD_PET:String = "addPet";
		
		public static const ADD_PET_EQUIP:String = "add_pet_equip";
		
		public static const DEL_PET_EQUIP:String = "del_pet_equip";
		
		public static const ENTER_FARM:String = "enterFarm";
		
		public static const FRUSH_FIELD:String = "frush_field";
		
		public static const GAIN_FIELD:String = "gainField";
		
		public static const PAY_FIELD:String = "payField";
		
		public static const SEEDING:String = "seeding";
		
		public static const COMPOSE_FOOD:String = "composeFood";
		
		public static const DO_MATURE:String = "doMature";
		
		public static const OPTION_CHANGE:String = "optionChange";
		
		public static const CHANGE_SEX:String = "changeSex";
		
		public static const HELPER_SWITCH:String = "helperSwitch";
		
		public static const KILL_CROP:String = "killCrop";
		
		public static const HELPER_PAY:String = "helperPay";
		
		public static const UPDATE_PLAYER_PROPERTY:String = "updateplayerproperty";
		
		public static const PLAYER_EXIT_FARM:String = "playerExitFarm";
		
		public static const FARM_LAND_INFO:String = "playerFarmLandInfo";
		
		public static const BUY_PET_EXP_ITEM:String = "BuyPetExpItem";
		
		public static const ARRANGE_FRIEND_FARM:String = "arrangeFriendFarm";
		
		public static const ENTER_TREASURE:String = "enterTreasure";
		
		public static const BEREPAIR_FRIEND_FARM_SEND:String = "beRepairFriendFarmSend";
		
		public static const END_TREASURE:String = "endTreasure";
		
		public static const DIG:String = "dig";
		
		public static const LOGIN_ABOUT_TREASURE:String = "LoginAboutTreasure";
		
		public static const START_GAME_TREASURE:String = "stratGameTreasure";
		
		public static const BEAD_HOLE_INFO:String = "beadHoleInfo";
		
		public static const BEAD_OPEN_PACKAGE:String = "getBead";
		
		public static const WORLDBOSS_INIT:String = "worldboss_init";
		
		public static const WORLDBOSS_OVER:String = "worldboss_over";
		
		public static const WORLDBOSS_ROOM:String = "worldboss_room";
		
		public static const WORLDBOSS_ROOM_LOGIN:String = "worldboss_room_login";
		
		public static const WORLDBOSS_MOVE:String = "worldboss_move";
		
		public static const WORLDBOSS_EXIT:String = "worldboss_exit";
		
		public static const WORLDBOSS_PLAYERSTAUTSUPDATE:String = "worldBoss_playerStautsUpdate";
		
		public static const WORLDBOSS_ROOMCLOSE:String = "worldBoss_roomclose";
		
		public static const WORLDBOSS_BLOOD_UPDATE:String = "boss_blood_update";
		
		public static const WORLDBOSS_ENTER:String = "worldboss_enter";
		
		public static const WORLDBOSS_FIGHTOVER:String = "worldboss_fightOver";
		
		public static const WORLDBOSS_RANKING:String = "worldboss_ranking";
		
		public static const WORLDBOSS_PLAYERREVIVE:String = "worldboss_revive";
		
		public static const WORLDBOSS_RANKING_INROOM:String = "worldboss_ranking_inroom";
		
		public static const WORLDBOSS_BUYBUFF:String = "worldboss_buy_buff";
		
		public static const WORLDBOSS_PRIVATE_INFO:String = "WORLDBOSS_PRIVATE_INFO";
		
		public static const WORLDBOSS_ASSISTANT:String = "WORLDBOSS_ASSISTANT";
		
		public static const WORLDBOSS_PLAYERFIGHTASSIATANT:String = "WORLDBOSS_PLAYERFIGHTASSIATANT";
		
		public static const NEWCHICKENBOX_OPEN:String = "newchickenbox_open";
		
		public static const NEWCHICKENBOX_CLOSE:String = "newchickenbox_close";
		
		public static const GET_NEWCHICKENBOX_LIST:String = "get_newchickenbox_list";
		
		public static const NEWCHICKENBOX_OPEN_CARD:String = "newchickenbox_open_card";
		
		public static const NEWCHICKENBOX_OPEN_EYE:String = "newchickenbox_open_eye";
		
		public static const CANCLICKCARDENABLE:String = "canclickcard";
		
		public static const OVERSHOWITEMS:String = "overshowitems";
		
		public static const DICE_ACTIVE_OPEN:String = "dice_active_open";
		
		public static const DICE_ACTIVE_CLOSE:String = "dice_active_close";
		
		public static const DICE_RECEIVE_DATA:String = "dice_receive_data";
		
		public static const DICE_RECEIVE_RESULT:String = "dice_receive_result";
		
		public static const DICE_START:String = "dice_start";
		
		public static const LUCKLYSTONE_ACTIVITY:String = "luck_stone_activity";
		
		public static const RELOAD_XML:String = "reloadXML";
		
		public static const TOTEM:String = "totem";
		
		public static const FIGHT_SPIRIT:String = "fight_spirit";
		
		public static const PLAYER_FIGHT_SPIRIT_UP:String = "player_fight_spirit_up";
		
		public static const FIGHT_SPIRIT_INIT:String = "fight_spirit_init";
		
		public static const CUMULATECHARGE_OPEN:String = "cumulatecharge_open";
		
		public static const CUMULATECHARGE_OVER:String = "cumulatecharge_over";
		
		public static const CUMULATECHARGE_DATA:String = "cumulatecharge_data";
		
		public static const GET_SPREE:String = "get_spree";
		
		public static const FIRSTRECHARGE_OPEN:String = "firstRecharge_open";
		
		public static const HONOR_UP_COUNT:String = "honor_up_count";
		
		public static const KING_BLESS_MAIN:String = "king_bless_main";
		
		public static const KING_BLESS_UPDATE_BUFF_DATA:String = "king_bless_update_buff_data";
		
		public static const SELECT_OBJECT:String = "selectObject";
		
		public static const CONSORTIA_BOSS_INFO:String = "consortia_boss_info";
		
		public static const TREASURE_DATA:String = "treasure_data";
		
		public static const LUCKSTONE_RANK_LIMIT:String = "luckstone_rank_limit";
		
		public static const LATENT_ENERGY:String = "latent_energy";
		
		public static const BATTLE_OPEN:String = "battle_open";
		
		public static const BATTLE_OVER:String = "battle_over";
		
		public static const BATTLEDATA_UPDATA:String = "battle_updata";
		
		public static const BATTLEDATA_UPDATA_REALTIME:String = "battle_updata_realtime";
		
		public static const PLAYER_DATA_UPDATA:String = "player_battle_updata";
		
		public static const TRANSNATIONAL_ROOM_BEGIN:String = "transnational_room_begin";
		
		public static const TRANSNATIONALFIGHT_ACTIVED:String = "transnationalfight_actived";
		
		public static const TRANSNATIONALFIGHT_PLAYERINFO:String = "transnationalfight_playerinfo";
		
		public static const TRANSNATIONALSCORE_UPDATA:String = "transnationalscore_updata";
		
		public static const TRANSNATIONALfIGHT_OVER:String = "transnationalfight_over";
		
		public static const USEMONEYPOINT_COMPLETE:String = "usemoneypoint_complete";
		
		public static const GETACTIVEPOINT_REWARD:String = "getactivepoint_reward";
		
		public static const EVERYDAYACTIVEPOINT_DATA:String = "everydayaactiviepoint_data";
		
		public static const EVERYDAYACTIVEPOINT_CHANGE:String = "everydayactivepoint_change";
		
		public static const ADD_ACTIVITY_DATA_CHANGE:String = "add_activity_data_change";
		
		public static const GET_EXPBLESSED_DATA:String = "get_expblessed_data";
		
		public static const WONDERFUL_ACTIVITY:String = "wonderfulActivity";
		
		public static const WONDERFUL_ACTIVITY_INIT:String = "wonderfulActivityInit";
		
		public static const NECKLACE_STRENGTH:String = "necklaceStrength";
		
		public static const CONSORTIA_BATTLE:String = "consortiaBattleEvent";
		
		public static const PlayerEnter:String = "buried_PlayerEnter";
		
		public static const PlayerRollDice:String = "buried_RollDice";
		
		public static const GainRewards:String = "gainRewards";
		
		public static const PlayerUpgradeStartLevel:String = "buried_PlayerUpgradeStartLevel";
		
		public static const BeforeStep:String = "buried_BeforeStep";
		
		public static const BackStep:String = "buried_BackStep";
		
		public static const ReachTheEnd:String = "buried_ReachTheEnd";
		
		public static const BackToStart:String = "buried_BackToStart";
		
		public static const GetGoods:String = "buried_GetGoods";
		
		public static const TakeCardResponse:String = "buried_takeCardResponse";
		
		public static const OneStep:String = "buried_oneStep";
		
		public static const RemoveEvent:String = "buried_removeEvent";
		
		public static const FlopCard:String = "buried_FlopCard";
		
		public static const PlayNowPosition:String = "buried_playerNowPosition";
		
		public static const QuitTakeCard:String = "buried_QuitTakeCard";
		
		public static const DRAGON_BOAT:String = "dragon_boat";
		
		public static const REQUEST_FRIENDS_PAY:String = "request_friends_pay";
		
		public static const CAMPBATTLE:String = "campbattle";
		
		public static const REGRESS_PACKS:String = "regress_pakcs";
		
		public static const REGRESS_CHECK:String = "regress_check";
		
		public static const REGRESS_APPLYPACKS:String = "regress_applypakcs";
		
		public static const REGRESS_APPLY_ENABLE:String = "regress_apply_enable";
		
		public static const REGRESS_GET_TICKET:String = "regress_get_ticket";
		
		public static const REGRESS_GET_TICKETINFO:String = "regress_get_ticketInfo";
		
		public static const REGRESS_CALLAPPLY:String = "regress_callaplly";
		
		public static const REGRESS_RECVPACKS:String = "regress_recvpacks";
		
		public static const Find_Back_Income:String = "find_back_income";
		
		public static const GAME_IN_COLOR_CHANGE:String = "game_in_color_change";
		
		public static const ADD_NEW_PLAYER:String = "add_new_player";
		
		public static const ADD_TERRACE:String = "add_terrace";
		
		public static const GROUP_PURCHASE:String = "group_purchase";
		
		public static const GAME_TRUSTEESHIP:String = "game_trusteeship";
		
		public static const UPDATE_LOGIN_FIGHTPOWER:String = "update_login_fightpower";
		
		public static const SEVEN_DOUBLE:String = "seven_double";
		
		public static const YY_VIP:String = "yy_vip";
		
		public static const INIT_TREASURE:String = "initTreasure";
		
		public static const PAY_FOR_HUNTING:String = "payForHunting";
		
		public static const HUNTING_BY_SCORE:String = "huntingByScore";
		
		public static const CONVERT_SCORE:String = "convertScore";
		
		public static const GET_MYSTERIOUS_DATA:String = "getMysteriousData";
		
		public static const DAWN_LOTTERY:String = "dawnLottery";
		
		public static const MISSION_ENERGY:String = "missionEnergy";
		
		public static const SINGLEBATTLE_STARTMATCH:String = "singleBattleStartMatch";
		
		public static const UPDATE_ACTIVITYDUNGEON_INFO:String = "update_activitydungeon_info";
		
		public static const ADD_ANIMATION:String = "add_animation";
		
		public static const AVATAR_COLLECTION:String = "avatar_collection";
		
		public static const ESCORT:String = "escort";
		
		public static const SEVEN_DOUBLE_ESCORT:String = "seven_double_escort";
		
		public static const DRGN_BAOT:String = "drgn_baot";
		
		public static const HORSE:String = "horse";
		
		public static const FOOD_ACTIVITY:String = "foodActivity";
		
		public static const COLLECTION_TASK:String = "collectionTask";
		
		public static const ROUND_ONE_END:String = "roundOneEnd";
		
		public static const SKILL_INFO_INIT:String = "skillInfoInit";
		
		public static const PYRAMID_SYSTEM:String = "pyramid_system";
		
		public static const PETISLANDINIT:String = "petIslandInit";
		
		public static const MAGICSTONE_DOUBLESCORE:String = "magicstone_doublescore";
		
		public static const FIGHTFOOTBALLTIME_ACTIVE:String = "fightFootballTime_active";
		
		public static const FIGHTFOOTBALLTIME_ROOM_CREATE:String = "fightFootballtime_room_create";
		
		public static const FIGHTFOOTBALLTIME_CMD:String = "fightFootballtime_cmd";
		
		public static const FIGHTFOOTBALLTIME_TAKEOUTALL:String = "fightFootballtime_takeoutall";
		
		public static const PYRAMID_ACTIVE_OPEN:String = "pyramid_active_open";
		
		public static const PYRAMID_ACTIVE_CLOSE:String = "pyramid_active_close";
		
		public static const CHRISTMAS_SYSTEM:String = "christmas_system";
		
		public static const SNOWMEN_UP:String = "snowmen_up";
		
		public static const CHRISTMAS_INIT:String = "christmas_init";
		
		public static const ACTIVE_STATE:String = "active_state";
		
		public static const FIGHT_MONSTER:String = "fight_monster";
		
		public static const SELF_MONSTER_INFO:String = "self_monster_info";
		
		public static const CHRISTMAS_MOVE:String = "christmas_move";
		
		public static const PLAYER_STATUE:String = "player_statue";
		
		public static const ADDPLAYER_ROOM:String = "addplayer_room";
		
		public static const CHRISTMAS_EXIT:String = "christmas_exit";
		
		public static const CHRISTMAS_MONSTER:String = "christmas_monster";
		
		public static const GET_PAKCS_TO_PLAYER:String = "getpackstoplayer";
		
		public static const CHRISTMAS_PACKS:String = "christmas_packs";
		
		public static const CHRISTMAS_ROOM_SPEAK:String = "christmas_room_speak";
		
		public static const UPDATE_TIMES_ROOM:String = "update_times_room";
		
		public static const UPDATE_SHOPLIMIT_COUNT:String = "update_shoplimit_count";
		
		public static const SUPER_WINNER:String = "super_winner";
		
		public static const GODS_ROADS:String = "gods_roads";
		
		public static const LUCKYSTAR_OPEN:String = "luckystaropen";
		
		public static const LUCKYSTAR_END:String = "luckystarend";
		
		public static const LUCKYSTAR_ALLGOODS:String = "luckystarallgoods";
		
		public static const LUCKYSTAR_RECORD:String = "luckystarrecord";
		
		public static const LUCKYSTAR_GOODSINFO:String = "luckystargoodsinfo";
		
		public static const LUCKYSTAR_REWARDINFO:String = "luckystarrewardinfo";
		
		public static const LUCKYSTAR_AWARDRANK:String = "luckystarawardrank";
		
		public static const GUILDMEMBERWEEK_SYSTEM:String = "guildmemberweek_system";
		
		public static const GUILDMEMBERWEEK_OPEN:String = "guildmemberweek_open";
		
		public static const GUILDMEMBERWEEK_CLOSE:String = "guildmemberweek_close";
		
		public static const GUILDMEMBERWEEK_PLAYERTOP10:String = "guildmemberweek_playertop10";
		
		public static const GUILDMEMBERWEEK_GET_POINTBOOK:String = "guildmemberweek_AddPointBook";
		
		public static const GUILDMEMBERWEEK_ADDPOINTBOOKRECORD:String = "guildmemberweek_addpointbookrecord";
		
		public static const GUILDMEMBERWEEK_FINISHACTIVITY:String = "guildmemberweek_finishactivity";
		
		public static const GUILDMEMBERWEEK_SHOWRUNKING:String = "guildmemberweek_showrunking";
		
		public static const GUILDMEMBERWEEK_GET_MYRUNKING:String = "guildmemberweek_getmyrunking";
		
		public static const GUILDMEMBERWEEK_GET_UPADDPOINTBOOK:String = "guildmemberweek_upaddpointbookrecord";
		
		public static const GUILDMEMBERWEEK_GET_SHOWACTIVITYEND:String = "guildmemberweek_showactivityend";
		
		public static const LANTERNRIDDLES_BEGIN:String = "lanternRiddles_begin";
		
		public static const LANTERNRIDDLES_QUESTION:String = "lanternRiddles_question";
		
		public static const LANTERNRIDDLES_ANSWERRESULT:String = "lanternRiddles_answer";
		
		public static const LANTERNRIDDLES_SKILL:String = "lanternRiddles_skill";
		
		public static const LANTERNRIDDLES_RANKINFO:String = "lanternRiddles_rankinfo";
		
		public static const CATCHBEAST_BEGIN:String = "catchbeast_begin";
		
		public static const CATCHBEAST_VIEWINFO:String = "catchbeast_viewinfo";
		
		public static const CATCHBEAST_CHALLENGE:String = "catchbeast_challenge";
		
		public static const CATCHBEAST_BUYBUFF:String = "catchbeast_buybuff";
		
		public static const CATCHBEAST_GETAWARD:String = "catchbeast_getaward";
		
		public static const LANTERNRIDDLES_BEGINTIPS:String = "lanternRiddles_beiginTips";
		
		public static const ACCUMULATIVELOGIN_AWARD:String = "accumulativeLogin_award";
		
		public static const REGRESS_UPDATE_INTEGRAL:String = "regressupdate_integral";
		
		public static const FAST_AUCTION_BUGLE:String = "fast_auction_bugle";
		
		public static const SINGBATTLE_FORCED_EXIT:String = "singleBattle_forecdExit";
		
		public static const PET_RISINGSTAR:String = "pet_risingStar";
		
		public static const PET_EVOLUTION:String = "pet_evolution";
		
		public static const PET_FORMINFO:String = "pet_formInfo";
		
		public static const PET_FOLLOW:String = "pet_follow";
		
		public static const PET_WAKE:String = "pet_wake";
		
		public static const PET_EAT:String = "pet_eat";
		
		public static const PEER_ID:String = "peerID";
		
		public static const TOTAL_CHARGE:String = "totalCharge";
		
		public static const FARM_POULTYRLEVEL:String = "farmpoultrylevel";
		
		public static const FARM_UPGRADEINITTREE:String = "farminittree";
		
		public static const FARM_WATER:String = "farmwater";
		
		public static const FARM_CONDENSER:String = "farmcondenser";
		
		public static const FARM_POULTYRFEED:String = "farmpoultryfeed";
		
		public static const ENTERTAINMENT:String = "entertainment";
		
		public static const HALLOWEEN:String = "halloween";
		
		public static const SEVENDAYTARGET_GODSROADS:String = "sevenDayTarget_godsroads";
		
		public static const SEVENDAYTARGET_NEWPLAYERREWARD:String = "sevenDayTarget_newplayerReward";
		
		public static const LIGHTROAD_SYSTEM:String = "lightroad_system";
		
		public static const CHICKACTIVATION_SYSTEM:String = "chickActivation_system";
		
		public static const DDPLAY_BEGIN:String = "DDPlay_brgin";
		
		public static const DDPLAY_ENTER:String = "DDPlay_enter";
		
		public static const DDPLAY_START:String = "DDPlay_start";
		
		public static const DDPLAY_EXCHANGE:String = "DDPlay_exchange";
		
		public static const BOGU_ADVENTURE:String = "boguadventure";
		
		public static const SHOP_BUYLIMITEDCOUNT:String = "shop_buylimitedcount";
		
		public static const GROWTHPACKAGE:String = "growthPackage";
		
		public static const GET_CSM_TIME_BOX:String = "getCSMTimeBox";
		
		public static const DEED_MAIN:String = "deed_main";
		
		public static const DEED_UPDATE_BUFF_DATA:String = "deed_update_buff_data";
		
		public static const WITCHBLESSING_DATA:String = "witchblessing_data";
		
		public static const TREASUREPUZZLE_SYSTEM:String = "treasurePuzzle_system";
		
		public static const ITEMACTIVITYGIFT_DATA:String = "itemActivityGift_data";
		
		public static const CRYPTBOSS:String = "cryptBoss";
		
		public static const RESCUE_ITEM_INFO:String = "RescueItemInfo";
		
		public static const RESCUE_KING_BLESS:String = "RescueKingBless";
		
		public static const ADD_SCORE:String = "addScore";
		
		public static const ITEM_ENCHANT:String = "item_enchant";
		
		public static const CLOUDBUY:String = "cloudBuy";
		
		public static const MAGICHOUSE:String = "magichouse";
		
		public static const TREASURELOST_SYSTEM:String = "treasureLost_system";
		
		public static const SHOW_HIDE_TITLE:String = "showHideTitle";
		
		public static const NEW_YEAR_RICE:String = "newYearRice";
		
		public static const DROP_GOODS:String = "dropGoods";
		
		public static const ZODIAC:String = "zodiac";
		
		public static const YEARFOODENTER:String = "yearFoodEnter";
		
		public static const YEARFOODCOOK:String = "yearFoodCook";
		
		public static const EXITYEARFOODROOM:String = "exitYearFoodRoom";
		
		public static const YEARFOODINVITE:String = "yearFoodInvite";
		
		public static const YEARFOODROOMINVITE:String = "yearFoodRoomInvite";
		
		public static const YEARFOODCREATEFOOD:String = "yearFoodCreateFood";
		
		public static const MAGIC_STONE_MONSTER_INFO:String = "MagicStoneMonster_Info";
		
		public static const VIP_MERRY_DISCOUNT:String = "vipMerryDiscount";
		
		public static const HORSERACE_OPEN_CLOSE:String = "horseRace_open_close";
		
		public static const HORSERACE_CMD:String = "horseRace_cmd";
		
		public static const INVITE_WAKE:String = "farmInvite_wake";
		
		public static const FARMBOSS_FULLLEVEL:String = "farmboss_fullLevel";
		
		public static const PRAY_INDIANA:String = "pray_indiana";
		
		public static const ANOTHERDIMENSION:String = "anotherDimension";
		
		public static const HAPPYRECHARGE:String = "happyRecharge";
		
		public static const RENSHEN:String = "renshen";
		
		public static const REDPACKET:String = "redpacket";
		
		public static const UPDATA_REDPACKTE_LIST:String = "updataRedPacketList";
		
		public static const REDPACKET_RECORD:String = "redpacketRecord";
		
		public static const MATCH_MESSAGE:String = "matchMessage";
		
		public static const MATCH_INFO:String = "matchInfo";
		
		public static const FIGHT_KING:String = "fightKing";
		
		public static const STORE_FINE_SUITS:String = "storeFineSuits";
		
		public static const CONSORTION_REDPACKAGE_GAIN_RECORD:String = "consortionRedPackageGain";
		
		public static const CONSORTION_REDPACKAGE_SEND_RECORD:String = "consortionRedPackageSend";
		
		public static const SKILL_LOCK:String = "skill_lock";
		
		public static const PET_BREAK:String = "pet_break";
		
		public static const PET_BREAK_INFO:String = "pet_break_info";
		
		public static const TARTGE_PLAYER:String = "target_player";
		
		public static const LUCKY_LOTTERY:String = "luckyLottery";
		
		public static const GOTO_CARD_LOTTERY:String = "gotoCardLottery";
		
		
		private var _pkg:PackageIn;
		
		public var executed:Boolean;
		
		public var _cmd:int;
		
		public function CrazyTankSocketEvent(param1:String, param2:PackageIn = null, param3:int = 0)
		{
			super(param1,bubbles,cancelable);
			this._pkg = param2;
			this._cmd = param3;
		}
		
		public function get pkg() : PackageIn
		{
			return this._pkg;
		}
	}
}
