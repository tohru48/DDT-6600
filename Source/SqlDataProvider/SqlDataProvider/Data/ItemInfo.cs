using System;

#nullable disable
namespace SqlDataProvider.Data
{
    public class ItemInfo : DataObject
    {
        private ItemTemplateInfo itemTemplateInfo_0;
        private ItemTemplateInfo itemTemplateInfo_1;
        private int int_0;
        private int int_1;
        private int int_2;
        private int int_3;
        private int int_4;
        private int int_5;
        private bool kmEkqNxdds;
        private string string_0;
        private bool bool_0;
        private int int_6;
        private int int_7;
        private int int_8;
        private int int_9;
        private int int_10;
        private int int_11;
        private bool bool_1;
        private bool bool_2;
        private bool bool_3;
        private string string_1;
        private DateTime dateTime_0;
        private int int_12;
        private DateTime dateTime_1;
        private int int_13;
        private int int_14;
        private int int_15;
        private int int_16;
        private int int_17;
        private int int_18;
        private int int_19;
        private int int_20;
        private int iMckyPjIpO;
        private int int_21;
        private int int_22;
        private int UgjkckwJqi;
        private bool bool_4;
        private int int_23;
        private DateTime dateTime_2;
        private string string_2;
        private string string_3;
        private DateTime dateTime_3;
        private bool bool_5;
        private bool bool_6;
        private int int_24;
        private int int_25;
        private bool bool_7;
        private bool bool_8;
        private int rYcktIcpiU;
        private int int_26;
        private int int_27;
        private int int_28;
        private DateTime dateTime_4;
        private bool bool_9;
        private int int_29;
        private int int_30;
        private int int_31;
        private int int_32;

        public ItemTemplateInfo Template => this.itemTemplateInfo_0;

        public ItemTemplateInfo GoldEquip
        {
            get => this.itemTemplateInfo_1 == null ? this.itemTemplateInfo_0 : this.itemTemplateInfo_1;
            set
            {
                this.itemTemplateInfo_1 = value;
                this._isDirty = true;
            }
        }

        public int ItemID
        {
            get => this.int_0;
            set
            {
                this.int_0 = value;
                this._isDirty = true;
            }
        }

        public int UserID
        {
            get => this.int_1;
            set
            {
                this.int_1 = value;
                this._isDirty = true;
            }
        }

        public int BagType
        {
            get => this.int_2;
            set
            {
                this.int_2 = value;
                this._isDirty = true;
            }
        }

        public int TemplateID
        {
            get => this.int_3;
            set
            {
                this.int_3 = value;
                this._isDirty = true;
            }
        }

        public int Place
        {
            get => this.int_4;
            set
            {
                this.int_4 = value;
                this._isDirty = true;
            }
        }

        public int Count
        {
            get => this.int_5;
            set
            {
                this.int_5 = value;
                this._isDirty = true;
            }
        }

        public bool IsJudge
        {
            get => this.kmEkqNxdds;
            set
            {
                this.kmEkqNxdds = value;
                this._isDirty = true;
            }
        }

        public string Color
        {
            get => this.string_0;
            set
            {
                this.string_0 = value;
                this._isDirty = true;
            }
        }

        public bool IsExist
        {
            get => this.bool_0;
            set
            {
                this.bool_0 = value;
                this._isDirty = true;
            }
        }

        public int StrengthenLevel
        {
            get => this.int_6;
            set
            {
                this.int_6 = value;
                this._isDirty = true;
            }
        }

        public int StrengthenExp
        {
            get => this.int_7;
            set
            {
                this.int_7 = value;
                this._isDirty = true;
            }
        }

        public int AttackCompose
        {
            get => this.int_8;
            set
            {
                this.int_8 = value;
                this._isDirty = true;
            }
        }

        public int DefendCompose
        {
            get => this.int_9;
            set
            {
                this.int_9 = value;
                this._isDirty = true;
            }
        }

        public int LuckCompose
        {
            get => this.int_10;
            set
            {
                this.int_10 = value;
                this._isDirty = true;
            }
        }

        public int AgilityCompose
        {
            get => this.int_11;
            set
            {
                this.int_11 = value;
                this._isDirty = true;
            }
        }

        public bool IsBinds
        {
            get => this.bool_1;
            set
            {
                this.bool_1 = value;
                this._isDirty = true;
            }
        }

        public bool IsUsed
        {
            get => this.bool_2;
            set
            {
                if (this.bool_2 == value)
                    return;
                this.bool_2 = value;
                this._isDirty = true;
            }
        }

        public bool goodsLock
        {
            get => this.bool_3;
            set
            {
                if (this.bool_3 == value)
                    return;
                this.bool_3 = value;
                this._isDirty = true;
            }
        }

        public string Skin
        {
            get => this.string_1;
            set
            {
                this.string_1 = value;
                this._isDirty = true;
            }
        }

        public DateTime BeginDate
        {
            get => this.dateTime_0;
            set
            {
                this.dateTime_0 = value;
                this._isDirty = true;
            }
        }

        public int ValidDate
        {
            get => this.int_12;
            set
            {
                this.int_12 = value > 999 ? 365 : value;
                this._isDirty = true;
            }
        }

        public DateTime RemoveDate
        {
            get => this.dateTime_1;
            set
            {
                this.dateTime_1 = value;
                this._isDirty = true;
            }
        }

        public int RemoveType
        {
            get => this.int_13;
            set
            {
                this.int_13 = value;
                this.dateTime_1 = DateTime.Now;
                this._isDirty = true;
            }
        }

        public int Hole1
        {
            get => this.int_14;
            set
            {
                this.int_14 = value;
                this._isDirty = true;
            }
        }

        public int Hole2
        {
            get => this.int_15;
            set
            {
                this.int_15 = value;
                this._isDirty = true;
            }
        }

        public int Hole3
        {
            get => this.int_16;
            set
            {
                this.int_16 = value;
                this._isDirty = true;
            }
        }

        public int Hole4
        {
            get => this.int_17;
            set
            {
                this.int_17 = value;
                this._isDirty = true;
            }
        }

        public int Hole5
        {
            get => this.int_18;
            set
            {
                this.int_18 = value;
                this._isDirty = true;
            }
        }

        public int Hole6
        {
            get => this.int_19;
            set
            {
                this.int_19 = value;
                this._isDirty = true;
            }
        }

        public int StrengthenTimes
        {
            get => this.int_20;
            set
            {
                this.int_20 = value;
                this._isDirty = true;
            }
        }

        public int Int32_0
        {
            get => this.iMckyPjIpO;
            set
            {
                this.iMckyPjIpO = value;
                this._isDirty = true;
            }
        }

        public int Int32_1
        {
            get => this.int_21;
            set
            {
                this.int_21 = value;
                this._isDirty = true;
            }
        }

        public int Hole5Exp
        {
            get => this.int_22;
            set
            {
                this.int_22 = value;
                this._isDirty = true;
            }
        }

        public int Hole6Exp
        {
            get => this.UgjkckwJqi;
            set
            {
                this.UgjkckwJqi = value;
                this._isDirty = true;
            }
        }

        public bool IsGold => this.IsValidGoldItem();

        public int goldValidDate
        {
            get => this.int_23;
            set
            {
                this.int_23 = value;
                this._isDirty = true;
            }
        }

        public DateTime goldBeginTime
        {
            get => this.dateTime_2;
            set
            {
                this.dateTime_2 = value;
                this._isDirty = true;
            }
        }

        public string latentEnergyCurStr
        {
            get => this.string_2;
            set
            {
                this.string_2 = value;
                this._isDirty = true;
            }
        }

        public string latentEnergyNewStr
        {
            get => this.string_3;
            set
            {
                this.string_3 = value;
                this._isDirty = true;
            }
        }

        public DateTime latentEnergyEndTime
        {
            get => this.dateTime_3;
            set
            {
                this.dateTime_3 = value;
                this._isDirty = true;
            }
        }

        public string Pic => this.IsGold ? this.GoldEquip.Pic : this.itemTemplateInfo_0.Pic;

        public int RefineryLevel
        {
            get => this.IsGold ? this.GoldEquip.RefineryLevel : this.itemTemplateInfo_0.RefineryLevel;
        }

        public int Attack
        {
            get
            {
                int attack = this.itemTemplateInfo_0.Attack;
                if (this.IsGold)
                    attack = this.GoldEquip.Attack;
                return this.int_8 + attack;
            }
        }

        public int Defence
        {
            get
            {
                int defence = this.itemTemplateInfo_0.Defence;
                if (this.IsGold)
                    defence = this.GoldEquip.Defence;
                return this.int_9 + defence;
            }
        }

        public int Agility
        {
            get
            {
                int agility = this.itemTemplateInfo_0.Agility;
                if (this.IsGold)
                    agility = this.GoldEquip.Agility;
                return this.int_11 + agility;
            }
        }

        public int Luck
        {
            get
            {
                int luck = this.itemTemplateInfo_0.Luck;
                if (this.IsGold)
                    luck = this.GoldEquip.Luck;
                return this.int_10 + luck;
            }
        }

        public bool IsTips
        {
            get => this.bool_5;
            set => this.bool_5 = value;
        }

        public bool IsLogs
        {
            get => this.bool_6;
            set => this.bool_6 = value;
        }

        public int beadExp
        {
            get => this.int_24;
            set
            {
                this.int_24 = value;
                this._isDirty = true;
            }
        }

        public int beadLevel
        {
            get => this.int_25;
            set
            {
                this.int_25 = value;
                this._isDirty = true;
            }
        }

        public bool beadIsLock
        {
            get => this.bool_7;
            set
            {
                this.bool_7 = value;
                this._isDirty = true;
            }
        }

        public bool isShowBind
        {
            get => this.bool_8;
            set
            {
                this.bool_8 = value;
                this._isDirty = true;
            }
        }

        public int Damage
        {
            get => this.rYcktIcpiU;
            set
            {
                this.rYcktIcpiU = value;
                this._isDirty = true;
            }
        }

        public int Guard
        {
            get => this.int_26;
            set
            {
                this.int_26 = value;
                this._isDirty = true;
            }
        }

        public int Blood
        {
            get => this.int_27;
            set
            {
                this.int_27 = value;
                this._isDirty = true;
            }
        }

        public int Bless
        {
            get => this.int_28;
            set
            {
                this.int_28 = value;
                this._isDirty = true;
            }
        }

        public DateTime AdvanceDate
        {
            get => this.dateTime_4;
            set
            {
                this.dateTime_4 = value;
                this._isDirty = true;
            }
        }

        public bool AvatarActivity
        {
            get => this.bool_9;
            set
            {
                if (this.bool_9 == value)
                    return;
                this.bool_9 = value;
                this._isDirty = true;
            }
        }

        public int MagicAttack
        {
            get => this.int_29;
            set
            {
                this.int_29 = value;
                this._isDirty = true;
            }
        }

        public int MagicDefence
        {
            get => this.int_30;
            set
            {
                this.int_30 = value;
                this._isDirty = true;
            }
        }

        public int MagicExp
        {
            get => this.int_31;
            set
            {
                this.int_31 = value;
                this._isDirty = true;
            }
        }

        public int MagicLevel
        {
            get => this.int_32;
            set
            {
                this.int_32 = value;
                this._isDirty = true;
            }
        }

        public int GetBagType => (int)this.itemTemplateInfo_0.BagType;

        public ItemInfo(ItemTemplateInfo temp) => this.itemTemplateInfo_0 = temp;

        public bool SameMagicstone(string type)
        {
            switch (type)
            {
                case "att":
                    return this.int_11 == 0 && this.int_8 > 0 && this.int_9 == 0 && this.int_10 == 0 && this.int_29 == 0 && this.int_30 == 0;
                case "def":
                    return this.int_11 == 0 && this.int_8 == 0 && this.int_9 > 0 && this.int_10 == 0 && this.int_29 == 0 && this.int_30 == 0;
                case "agi":
                    return this.int_11 > 0 && this.int_8 == 0 && this.int_9 == 0 && this.int_10 == 0 && this.int_29 == 0 && this.int_30 == 0;
                case "luc":
                    return this.int_11 == 0 && this.int_8 == 0 && this.int_9 == 0 && this.int_10 > 0 && this.int_29 == 0 && this.int_30 == 0;
                case "mgatt":
                    return this.int_11 == 0 && this.int_8 == 0 && this.int_9 == 0 && this.int_10 == 0 && this.int_29 > 0 && this.int_30 == 0;
                case "mgdef":
                    return this.int_11 == 0 && this.int_8 == 0 && this.int_9 == 0 && this.int_10 == 0 && this.int_29 == 0 && this.int_30 > 0;
                default:
                    return false;
            }
        }

        public bool IsEnchant()
        {
            switch (this.Template.CategoryID)
            {
                case 8:
                case 9:
                    return this.Template.Property1 == 5;
                default:
                    return false;
            }
        }

        public bool IsAdvanceDate() => this.dateTime_4.Date < DateTime.Now.Date;

        public ItemInfo Clone()
        {
            ItemInfo itemInfo = new ItemInfo(this.itemTemplateInfo_0);
            itemInfo.int_1 = this.int_1;
            itemInfo.int_12 = this.int_12;
            itemInfo.int_3 = this.int_3;
            itemInfo.itemTemplateInfo_1 = this.itemTemplateInfo_1;
            itemInfo.int_6 = this.int_6;
            itemInfo.int_7 = this.int_7;
            itemInfo.int_10 = this.int_10;
            itemInfo.int_0 = 0;
            itemInfo.kmEkqNxdds = this.kmEkqNxdds;
            itemInfo.bool_0 = this.bool_0;
            itemInfo.bool_1 = this.bool_1;
            itemInfo.bool_2 = this.bool_2;
            itemInfo.int_9 = this.int_9;
            itemInfo.int_5 = this.int_5;
            itemInfo.string_0 = this.string_0;
            itemInfo.Skin = this.string_1;
            itemInfo.dateTime_0 = this.dateTime_0;
            itemInfo.int_8 = this.int_8;
            itemInfo.int_11 = this.int_11;
            itemInfo.int_2 = this.int_2;
            itemInfo._isDirty = true;
            itemInfo.dateTime_1 = this.dateTime_1;
            itemInfo.int_13 = this.int_13;
            itemInfo.int_14 = this.int_14;
            itemInfo.int_15 = this.int_15;
            itemInfo.int_16 = this.int_16;
            itemInfo.int_17 = this.int_17;
            itemInfo.int_18 = this.int_18;
            itemInfo.int_19 = this.int_19;
            itemInfo.int_22 = this.int_22;
            itemInfo.iMckyPjIpO = this.iMckyPjIpO;
            itemInfo.UgjkckwJqi = this.UgjkckwJqi;
            itemInfo.int_21 = this.int_21;
            itemInfo.bool_4 = this.bool_4;
            itemInfo.dateTime_2 = this.dateTime_2;
            itemInfo.int_23 = this.int_23;
            itemInfo.string_2 = this.string_2;
            itemInfo.string_3 = this.string_3;
            itemInfo.dateTime_3 = this.dateTime_3;
            itemInfo.int_24 = this.int_24;
            itemInfo.int_25 = this.int_25;
            itemInfo.bool_7 = this.bool_7;
            itemInfo.bool_8 = this.bool_8;
            itemInfo.rYcktIcpiU = this.rYcktIcpiU;
            itemInfo.int_26 = this.int_26;
            itemInfo.int_28 = this.int_28;
            itemInfo.int_27 = this.int_27;
            itemInfo.AdvanceDate = this.dateTime_4;
            itemInfo.bool_9 = this.bool_9;
            itemInfo.bool_3 = this.bool_3;
            itemInfo.int_29 = this.int_29;
            itemInfo.int_30 = this.int_30;
            itemInfo.int_31 = this.int_31;
            itemInfo.int_32 = this.int_32;
            return itemInfo;
        }

        public bool IsValidItem()
        {
            return this.int_12 == 0 || !this.bool_2 || DateTime.Compare(this.dateTime_0.AddDays((double)this.int_12), DateTime.Now) > 0;
        }

        public bool IsValidGoldItem()
        {
            return this.int_23 > 0 && DateTime.Compare(this.dateTime_2.AddDays((double)this.int_23), DateTime.Now) > 0;
        }

        public bool IsValidLatentEnergy() => this.dateTime_3.Date < DateTime.Now.Date;

        public void ResetLatentEnergy()
        {
            this.string_2 = "0,0,0,0";
            this.string_3 = "0,0,0,0";
        }

        public bool CanLatentEnergy()
        {
            switch (this.Template.CategoryID)
            {
                case 2:
                case 3:
                case 4:
                case 6:
                    return true;
                case 13:
                case 15:
                    return true;
                default:
                    return false;
            }
        }

        public bool CanStackedTo(ItemInfo to)
        {
            return this.int_3 == to.TemplateID && this.Template.MaxCount > 1 && this.bool_1 == to.IsBinds && this.bool_2 == to.bool_2 && (this.ValidDate == 0 || this.BeginDate.Date == to.BeginDate.Date && this.ValidDate == this.ValidDate);
        }

        public int eqType()
        {
            switch (this.itemTemplateInfo_0.CategoryID)
            {
                case 51:
                    return 1;
                case 52:
                    return 2;
                default:
                    return 0;
            }
        }

        public bool IsProp()
        {
            int categoryId = this.itemTemplateInfo_0.CategoryID;
            if (categoryId <= 18)
            {
                if (categoryId == 11 || categoryId == 18)
                    return true;
            }
            else
            {
                switch (categoryId - 32)
                {
                    case 0:
                    case 2:
                    case 3:
                        return true;
                    case 1:
                        break;
                    default:
                        if (categoryId == 40)
                            return true;
                        goto case 1;
                }
            }
            return false;
        }

        public bool CanEquip()
        {
            return this.itemTemplateInfo_0.CategoryID < 10 || this.itemTemplateInfo_0.CategoryID >= 13 && this.itemTemplateInfo_0.CategoryID <= 16;
        }

        public string GetBagName()
        {
            switch (this.itemTemplateInfo_0.CategoryID)
            {
                case 10:
                case 11:
                    return "Game.Server.GameObjects.Prop";
                case 12:
                    return "Game.Server.GameObjects.Task";
                default:
                    return "Game.Server.GameObjects.Equip";
            }
        }

        public static ItemInfo CreateFromTemplate(ItemTemplateInfo goods, int count, int type)
        {
            if (goods == null)
                return (ItemInfo)null;
            ItemInfo fromTemplate = new ItemInfo(goods);
            fromTemplate.AgilityCompose = 0;
            fromTemplate.AttackCompose = 0;
            fromTemplate.BeginDate = DateTime.Now;
            fromTemplate.Color = "";
            fromTemplate.Skin = "";
            fromTemplate.DefendCompose = 0;
            fromTemplate.IsUsed = false;
            fromTemplate.IsDirty = false;
            fromTemplate.IsExist = true;
            fromTemplate.IsJudge = true;
            fromTemplate.LuckCompose = 0;
            fromTemplate.StrengthenLevel = 0;
            fromTemplate.TemplateID = goods.TemplateID;
            fromTemplate.ValidDate = 0;
            fromTemplate.Count = count;
            fromTemplate.IsBinds = goods.BindType == 1;
            fromTemplate.dateTime_1 = DateTime.Now;
            fromTemplate.int_13 = type;
            fromTemplate.Hole1 = -1;
            fromTemplate.Hole2 = -1;
            fromTemplate.Hole3 = -1;
            fromTemplate.Hole4 = -1;
            fromTemplate.Hole5 = -1;
            fromTemplate.Hole6 = -1;
            fromTemplate.Hole5Exp = 0;
            fromTemplate.Int32_0 = 0;
            fromTemplate.Hole6Exp = 0;
            fromTemplate.Int32_1 = 0;
            fromTemplate.goldValidDate = 0;
            fromTemplate.goldBeginTime = DateTime.Now;
            fromTemplate.StrengthenExp = 0;
            fromTemplate.latentEnergyCurStr = "0,0,0,0";
            fromTemplate.latentEnergyNewStr = "0,0,0,0";
            fromTemplate.latentEnergyEndTime = DateTime.Now;
            fromTemplate.beadExp = 0;
            fromTemplate.beadLevel = 0;
            fromTemplate.beadIsLock = false;
            fromTemplate.isShowBind = false;
            fromTemplate.Damage = 0;
            fromTemplate.Guard = 0;
            fromTemplate.Bless = 0;
            fromTemplate.Blood = 0;
            fromTemplate.AdvanceDate = DateTime.Now;
            fromTemplate.AvatarActivity = false;
            fromTemplate.goodsLock = false;
            fromTemplate.MagicAttack = 0;
            fromTemplate.MagicDefence = 0;
            fromTemplate.MagicExp = 0;
            fromTemplate.MagicLevel = 0;
            return fromTemplate;
        }

        public static ItemInfo CloneFromTemplate(ItemTemplateInfo goods, ItemInfo item)
        {
            if (goods == null)
                return (ItemInfo)null;
            ItemInfo itemInfo = new ItemInfo(goods);
            itemInfo.AgilityCompose = item.AgilityCompose;
            itemInfo.AttackCompose = item.AttackCompose;
            itemInfo.BeginDate = item.BeginDate;
            itemInfo.Color = item.Color;
            itemInfo.Skin = item.Skin;
            itemInfo.DefendCompose = item.DefendCompose;
            itemInfo.IsBinds = item.IsBinds;
            itemInfo.Place = item.Place;
            itemInfo.BagType = item.BagType;
            itemInfo.IsUsed = item.IsUsed;
            itemInfo.IsDirty = item.IsDirty;
            itemInfo.IsExist = item.IsExist;
            itemInfo.IsJudge = item.IsJudge;
            itemInfo.LuckCompose = item.LuckCompose;
            itemInfo.StrengthenExp = item.StrengthenExp;
            itemInfo.StrengthenLevel = item.StrengthenLevel;
            itemInfo.TemplateID = goods.TemplateID;
            itemInfo.ValidDate = item.ValidDate;
            itemInfo.itemTemplateInfo_0 = goods;
            itemInfo.Count = item.Count;
            itemInfo.dateTime_1 = item.dateTime_1;
            itemInfo.int_13 = item.int_13;
            itemInfo.Hole1 = item.Hole1;
            itemInfo.Hole2 = item.Hole2;
            itemInfo.Hole3 = item.Hole3;
            itemInfo.Hole4 = item.Hole4;
            itemInfo.Hole5 = item.Hole5;
            itemInfo.Hole6 = item.Hole6;
            itemInfo.Int32_0 = item.Int32_0;
            itemInfo.Hole5Exp = item.Hole5Exp;
            itemInfo.Int32_1 = item.Int32_1;
            itemInfo.Hole6Exp = item.Hole6Exp;
            itemInfo.goldBeginTime = item.goldBeginTime;
            itemInfo.goldValidDate = item.goldValidDate;
            itemInfo.latentEnergyEndTime = item.latentEnergyEndTime;
            itemInfo.latentEnergyCurStr = item.latentEnergyCurStr;
            itemInfo.latentEnergyNewStr = item.latentEnergyNewStr;
            itemInfo.AdvanceDate = item.AdvanceDate;
            itemInfo.goodsLock = item.goodsLock;
            itemInfo.MagicAttack = item.MagicAttack;
            itemInfo.MagicDefence = item.MagicDefence;
            itemInfo.MagicExp = item.MagicExp;
            itemInfo.MagicLevel = item.MagicLevel;
            if (item.isDress())
                itemInfo.AvatarActivity = item.AvatarActivity;
            ItemInfo.OpenHole(ref itemInfo);
            return itemInfo;
        }

        public bool IsBead()
        {
            return this.itemTemplateInfo_0.Property1 == 31 && this.itemTemplateInfo_0.CategoryID == 11;
        }

        public bool IsEquipPet()
        {
            return this.itemTemplateInfo_0.CategoryID == 50 || this.itemTemplateInfo_0.CategoryID == 51 || this.itemTemplateInfo_0.CategoryID == 52;
        }

        public bool IsCard()
        {
            int categoryId = this.itemTemplateInfo_0.CategoryID;
            return categoryId != 11 ? categoryId == 18 : this.itemTemplateInfo_0.TemplateID == 112108 || this.itemTemplateInfo_0.TemplateID == 112150;
        }

        public bool IsPuzzle()
        {
            switch (this.int_3)
            {
                case 201386:
                case 201387:
                case 201388:
                case 201389:
                case 201390:
                case 201391:
                    return true;
                default:
                    return false;
            }
        }

        public int GetRemainDate()
        {
            if (this.ValidDate == 0)
                return int.MaxValue;
            if (!this.bool_2)
                return this.ValidDate;
            int num = DateTime.Compare(this.dateTime_0.AddDays((double)this.int_12), DateTime.Now);
            return num < 0 ? 0 : num;
        }

        public bool isDress()
        {
            switch (this.itemTemplateInfo_0.CategoryID)
            {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                case 13:
                case 15:
                    return true;
                case 7:
                case 8:
                case 9:
                case 10:
                case 11:
                case 12:
                case 14:
                    return false;
                default:
                    return false;
            }
        }

        public bool isDrill(int holelv)
        {
            switch (this.itemTemplateInfo_0.TemplateID)
            {
                case 11026:
                    return holelv == 2;
                case 11027:
                    return holelv == 3;
                case 11034:
                    return holelv == 4;
                case 11035:
                    return holelv == 0;
                case 11036:
                    return holelv == 1;
                default:
                    return false;
            }
        }

        public bool isTexp() => this.itemTemplateInfo_0.CategoryID == 20;

        public bool isGemStone()
        {
            switch (this.itemTemplateInfo_0.TemplateID)
            {
                case 100100:
                case 201264:
                    return true;
                default:
                    return false;
            }
        }

        public static void OpenHole(ref ItemInfo item)
        {
            string[] strArray1 = item.Template.Hole.Split('|');
            for (int index = 0; index < strArray1.Length; ++index)
            {
                string[] strArray2 = strArray1[index].Split(',');
                if (item.StrengthenLevel >= Convert.ToInt32(strArray2[0]) && Convert.ToInt32(strArray2[1]) != -1)
                {
                    switch (index)
                    {
                        case 0:
                            if (item.Hole1 < 0)
                            {
                                item.Hole1 = 0;
                                break;
                            }
                            break;
                        case 1:
                            if (item.Hole2 < 0)
                            {
                                item.Hole2 = 0;
                                break;
                            }
                            break;
                        case 2:
                            if (item.Hole3 < 0)
                            {
                                item.Hole3 = 0;
                                break;
                            }
                            break;
                        case 3:
                            if (item.Hole4 < 0)
                            {
                                item.Hole4 = 0;
                                break;
                            }
                            break;
                        case 4:
                            if (item.Hole5 < 0)
                            {
                                item.Hole5 = 0;
                                break;
                            }
                            break;
                        case 5:
                            if (item.Hole6 < 0)
                            {
                                item.Hole6 = 0;
                                break;
                            }
                            break;
                    }
                }
            }
        }

        private int m_Hole5Level;
        private int m_Hole6Level;
        public int Hole5Level
        {
            get => this.m_Hole5Level;
            set
            {
                this.m_Hole5Level = value;
                this._isDirty = true;
            }
        }

        public int Hole6Level
        {
            get => this.m_Hole6Level;
            set
            {
                this.m_Hole6Level = value;
                this._isDirty = true;
            }
        }
    }
}
