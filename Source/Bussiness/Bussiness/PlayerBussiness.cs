using Bussiness.CenterService;
using Bussiness.Managers;
using SqlDataProvider.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

#nullable disable
namespace Bussiness
{
    public class PlayerBussiness : BaseBussiness
    {
        public int ActiveChickCode(int UserID, string Code)
        {
            int num = 3;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[3]
                {
          new SqlParameter("@UserID", (object) UserID),
          new SqlParameter("@ActiveCode", (object) Code),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[2].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Active_ChickCode", SqlParameters);
                num = (int)SqlParameters[2].Value;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return num;
        }

        public AchievementDataInfo[] GetAllAchievementData(int userID)
        {
            List<AchievementDataInfo> achievementDataInfoList = new List<AchievementDataInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", (object) userID)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Achievement_Data_All", SqlParameters);
                while (ResultDataReader.Read())
                    achievementDataInfoList.Add(this.InitAchievementData(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetAllAchievementData), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return achievementDataInfoList.ToArray();
        }

        public bool UpdateAchievementData(AchievementDataInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_AchievementData_Add", new SqlParameter[4]
                {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@AchievementID", (object) info.AchievementID),
          new SqlParameter("@CompletedDate", (object) info.CompletedDate),
          new SqlParameter("@IsComplete", (object) info.IsComplete)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Gypsy_Item_Data_Update", ex);
            }
            return flag;
        }

        public AchievementDataInfo InitAchievementData(SqlDataReader reader)
        {
            return new AchievementDataInfo()
            {
                UserID = (int)reader["UserID"],
                AchievementID = (int)reader["AchievementID"],
                IsComplete = (bool)reader["IsComplete"],
                CompletedDate = (DateTime)reader["CompletedDate"]
            };
        }

        public bool UpdateGypsyItemData(GypsyItemDataInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Gypsy_Item_Data_Update", new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@GypsyID", (object) info.GypsyID),
          new SqlParameter("@InfoID", (object) info.InfoID),
          new SqlParameter("@Unit", (object) info.Unit),
          new SqlParameter("@Num", (object) info.Num),
          new SqlParameter("@Price", (object) info.Price),
          new SqlParameter("@CanBuy", (object) info.CanBuy)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Gypsy_Item_Data_Update", ex);
            }
            return flag;
        }

        public bool AddGypsyItemData(GypsyItemDataInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@GypsyID", (object) info.GypsyID),
          new SqlParameter("@InfoID", (object) info.InfoID),
          new SqlParameter("@Unit", (object) info.Unit),
          new SqlParameter("@Num", (object) info.Num),
          new SqlParameter("@Price", (object) info.Price),
          new SqlParameter("@CanBuy", (object) info.CanBuy)
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                flag = this.db.RunProcedure("SP_Gypsy_Item_Data_Add", SqlParameters);
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Gypsy_Item_Data_Add", ex);
            }
            return flag;
        }

        public GypsyItemDataInfo[] GetAllGypsyItemDataByID(int ID)
        {
            List<GypsyItemDataInfo> gypsyItemDataInfoList = new List<GypsyItemDataInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)ID;
                this.db.GetReader(ref ResultDataReader, "SP_Gypsy_Item_Data_All", SqlParameters);
                while (ResultDataReader.Read())
                    gypsyItemDataInfoList.Add(this.InitGypsyItemDataInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitGypsyItemDataInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return gypsyItemDataInfoList.ToArray();
        }

        public GypsyItemDataInfo InitGypsyItemDataInfo(SqlDataReader dr)
        {
            return new GypsyItemDataInfo()
            {
                ID = (int)dr["ID"],
                UserID = (int)dr["UserID"],
                GypsyID = (int)dr["GypsyID"],
                InfoID = (int)dr["InfoID"],
                Unit = (int)dr["Unit"],
                Num = (int)dr["Num"],
                Price = (int)dr["Price"],
                CanBuy = (int)dr["CanBuy"]
            };
        }

        public CloudBuyLogInfo[] GetAllCloudBuyLog()
        {
            List<CloudBuyLogInfo> cloudBuyLogInfoList = new List<CloudBuyLogInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Cloud_Buy_Log_All");
                while (ResultDataReader.Read())
                    cloudBuyLogInfoList.Add(this.InitCloudBuyLogInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitCloudBuyLogInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return cloudBuyLogInfoList.ToArray();
        }

        public CloudBuyLogInfo InitCloudBuyLogInfo(SqlDataReader dr)
        {
            return new CloudBuyLogInfo()
            {
                ID = (int)dr["ID"],
                UserID = (int)dr["UserID"],
                nickName = dr["nickName"] == null ? "" : dr["nickName"].ToString(),
                templateId = (int)dr["templateId"],
                validate = (int)dr["validate"],
                count = (int)dr["count"],
                property = dr["property"] == null ? "" : dr["property"].ToString()
            };
        }

        public bool AddCloudBuyLog(CloudBuyLogInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Cloud_Buy_Log_Add", new SqlParameter[7]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@nickName", (object) info.nickName),
          new SqlParameter("@templateId", (object) info.templateId),
          new SqlParameter("@validate", (object) info.validate),
          new SqlParameter("@count", (object) info.count),
          new SqlParameter("@property", (object) info.property)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Cloud_Buy_Log_Add", ex);
            }
            return flag;
        }

        public CloudBuyLotteryInfo[] GetAllCloudBuyLottery()
        {
            List<CloudBuyLotteryInfo> cloudBuyLotteryInfoList = new List<CloudBuyLotteryInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Cloud_Buy_Lottery_All");
                while (ResultDataReader.Read())
                    cloudBuyLotteryInfoList.Add(this.InitCloudBuyLotteryInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitCloudBuyLotteryInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return cloudBuyLotteryInfoList.ToArray();
        }

        public CloudBuyLotteryInfo InitCloudBuyLotteryInfo(SqlDataReader dr)
        {
            return new CloudBuyLotteryInfo()
            {
                ID = (int)dr["ID"],
                templateId = (int)dr["templateId"],
                templatedIdCount = (int)dr["templatedIdCount"],
                validDate = (int)dr["validDate"],
                property = dr["property"] == null ? "" : dr["property"].ToString(),
                buyItemsArr = dr["buyItemsArr"] == null ? "" : dr["buyItemsArr"].ToString(),
                buyMoney = (int)dr["buyMoney"],
                maxNum = (int)dr["maxNum"],
                currentNum = (int)dr["currentNum"]
            };
        }

        public bool UpdateCloudBuyLottery(CloudBuyLotteryInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Cloud_Buy_Lottery_Update", new SqlParameter[9]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@templateId", (object) info.templateId),
          new SqlParameter("@templatedIdCount", (object) info.templatedIdCount),
          new SqlParameter("@validDate", (object) info.validDate),
          new SqlParameter("@property", (object) info.property),
          new SqlParameter("@buyItemsArr", (object) info.buyItemsArr),
          new SqlParameter("@buyMoney", (object) info.buyMoney),
          new SqlParameter("@maxNum", (object) info.maxNum),
          new SqlParameter("@currentNum", (object) info.currentNum)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Cloud_Buy_Lottery_Update", ex);
            }
            return flag;
        }

        public bool ResetLuckCount()
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Reset_Luck_Count", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Reset_Luck_Count", ex);
            }
            return flag;
        }

        public bool UpdateHalloweenRank(HalloweenRankInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Halloween_Rank_Update", new SqlParameter[5]
                {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@useNum", (object) info.useNum),
          new SqlParameter("@nickName", (object) info.nickName),
          new SqlParameter("@isVip", (object) info.isVip),
          new SqlParameter("@rank", (object) info.rank)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Halloween_Rank_Update", ex);
            }
            return flag;
        }

        public WarriorFamRankInfo[] GetAllWarriorFamRank()
        {
            List<WarriorFamRankInfo> warriorFamRankInfoList = new List<WarriorFamRankInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            int num = 1;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[0];
                this.db.GetReader(ref ResultDataReader, "SP_Get_All_Warrior_Fam_Rank_All", SqlParameters);
                while (ResultDataReader.Read())
                {
                    warriorFamRankInfoList.Add(new WarriorFamRankInfo()
                    {
                        PlayerRank = num,
                        PlayerName = ResultDataReader["NickName"] == null ? "" : ResultDataReader["NickName"].ToString(),
                        FamLevel = (int)ResultDataReader["myProgress"]
                    });
                    ++num;
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Get_All_Warrior_Fam_Rank_All", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return warriorFamRankInfoList.ToArray();
        }

        public HalloweenRankInfo[] GetAllHalloweenRank()
        {
            List<HalloweenRankInfo> halloweenRankInfoList = new List<HalloweenRankInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Halloween_Rank_All");
                while (ResultDataReader.Read())
                    halloweenRankInfoList.Add(this.InitHalloweenRankInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitHalloweenRankInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return halloweenRankInfoList.ToArray();
        }

        public HalloweenRankInfo InitHalloweenRankInfo(SqlDataReader dr)
        {
            return new HalloweenRankInfo()
            {
                ID = (int)dr["ID"],
                UserID = (int)dr["UserID"],
                useNum = (int)dr["useNum"],
                nickName = dr["nickName"] == null ? "" : dr["nickName"].ToString(),
                isVip = (int)dr["isVip"],
                rank = (int)dr["rank"]
            };
        }

        public bool AddBoguAdventureData(BoguAdventureDataInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[13]
                {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@currentIndex", (object) info.currentIndex),
          new SqlParameter("@hp", (object) info.hp),
          new SqlParameter("@isAcquireAward1", (object) info.isAcquireAward1),
          new SqlParameter("@isAcquireAward2", (object) info.isAcquireAward2),
          new SqlParameter("@isAcquireAward3", (object) info.isAcquireAward3),
          new SqlParameter("@openCount", (object) info.openCount),
          new SqlParameter("@isFreeReset", (object) info.isFreeReset),
          new SqlParameter("@resetCount", (object) info.resetCount),
          new SqlParameter("@cellInfo", (object) info.cellInfo),
          new SqlParameter("@awardCount", (object) info.awardCount),
          new SqlParameter("@ID", (object) info.ID),
          null
                };
                SqlParameters[11].Direction = ParameterDirection.Output;
                SqlParameters[12] = new SqlParameter("@lastEnterGame", (object)info.lastEnterGame);
                flag = this.db.RunProcedure("SP_BoguAdventure_Data_Add", SqlParameters);
                info.ID = (int)SqlParameters[11].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_BoguAdventure_Data_Add", ex);
            }
            return flag;
        }

        public bool UpdateBoguAdventureData(BoguAdventureDataInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_BoguAdventure_Data_Update", new SqlParameter[13]
                {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@currentIndex", (object) info.currentIndex),
          new SqlParameter("@hp", (object) info.hp),
          new SqlParameter("@isAcquireAward1", (object) info.isAcquireAward1),
          new SqlParameter("@isAcquireAward2", (object) info.isAcquireAward2),
          new SqlParameter("@isAcquireAward3", (object) info.isAcquireAward3),
          new SqlParameter("@openCount", (object) info.openCount),
          new SqlParameter("@isFreeReset", (object) info.isFreeReset),
          new SqlParameter("@resetCount", (object) info.resetCount),
          new SqlParameter("@cellInfo", (object) info.cellInfo),
          new SqlParameter("@awardCount", (object) info.awardCount),
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@lastEnterGame", (object) info.lastEnterGame)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_BoguAdventure_Data_Update", ex);
            }
            return flag;
        }

        public BoguAdventureDataInfo GetAllBoguAdventureDataByID(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_BoguAdventure_Data_All", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitBoguAdventureDataInfo(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitBoguAdventureDataInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (BoguAdventureDataInfo)null;
        }

        public BoguAdventureDataInfo InitBoguAdventureDataInfo(SqlDataReader dr)
        {
            return new BoguAdventureDataInfo()
            {
                ID = (int)dr["ID"],
                UserID = (int)dr["UserID"],
                currentIndex = (int)dr["currentIndex"],
                hp = (int)dr["hp"],
                isAcquireAward1 = (int)dr["isAcquireAward1"],
                isAcquireAward2 = (int)dr["isAcquireAward2"],
                isAcquireAward3 = (int)dr["isAcquireAward3"],
                openCount = (int)dr["openCount"],
                isFreeReset = (bool)dr["isFreeReset"],
                resetCount = (int)dr["resetCount"],
                cellInfo = dr["cellInfo"] == null ? "" : dr["cellInfo"].ToString(),
                awardCount = dr["awardCount"] == null ? "" : dr["awardCount"].ToString(),
                lastEnterGame = (DateTime)dr["lastEnterGame"]
            };
        }

        public bool AddRingstationConfig(RingstationConfigInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[11]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@ChallengeNum", (object) info.ChallengeNum),
          new SqlParameter("@buyCount", (object) info.buyCount),
          new SqlParameter("@buyPrice", (object) info.buyPrice),
          new SqlParameter("@cdPrice", (object) info.cdPrice),
          new SqlParameter("@AwardTime", (object) info.AwardTime),
          new SqlParameter("@AwardNum", (object) info.AwardNum),
          new SqlParameter("@AwardFightWin", (object) info.AwardFightWin),
          new SqlParameter("@AwardFightLost", (object) info.AwardFightLost),
          new SqlParameter("@ChampionText", (object) info.ChampionText),
          new SqlParameter("@IsFirstUpdateRank", (object) info.IsFirstUpdateRank)
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                flag = this.db.RunProcedure("SP_Ringstation_Config_Add", SqlParameters);
                info.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Ringstation_Config_Add", ex);
            }
            return flag;
        }

        public bool UpdateRingstationConfig(RingstationConfigInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Ringstation_Config_Update", new SqlParameter[11]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@ChallengeNum", (object) info.ChallengeNum),
          new SqlParameter("@buyCount", (object) info.buyCount),
          new SqlParameter("@buyPrice", (object) info.buyPrice),
          new SqlParameter("@cdPrice", (object) info.cdPrice),
          new SqlParameter("@AwardTime", (object) info.AwardTime),
          new SqlParameter("@AwardNum", (object) info.AwardNum),
          new SqlParameter("@AwardFightWin", (object) info.AwardFightWin),
          new SqlParameter("@AwardFightLost", (object) info.AwardFightLost),
          new SqlParameter("@ChampionText", (object) info.ChampionText),
          new SqlParameter("@IsFirstUpdateRank", (object) info.IsFirstUpdateRank)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Ringstation_Config_Update", ex);
            }
            return flag;
        }

        public RingstationConfigInfo GetAllRingstationConfig()
        {
            List<RingstationConfigInfo> ringstationConfigInfoList = new List<RingstationConfigInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Ringstation_Config_All");
                if (ResultDataReader.Read())
                    return this.InitRingstationConfigInfo(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitRingstationConfigInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (RingstationConfigInfo)null;
        }

        public RingstationConfigInfo InitRingstationConfigInfo(SqlDataReader dr)
        {
            return new RingstationConfigInfo()
            {
                ID = (int)dr["ID"],
                ChallengeNum = (int)dr["ChallengeNum"],
                buyCount = (int)dr["buyCount"],
                buyPrice = (int)dr["buyPrice"],
                cdPrice = (int)dr["cdPrice"],
                AwardTime = (DateTime)dr["AwardTime"],
                AwardNum = (int)dr["AwardNum"],
                AwardFightWin = dr["AwardFightWin"] == null ? "" : dr["AwardFightWin"].ToString(),
                AwardFightLost = dr["AwardFightLost"] == null ? "" : dr["AwardFightLost"].ToString(),
                ChampionText = dr["ChampionText"] == null ? "" : dr["ChampionText"].ToString(),
                IsFirstUpdateRank = (bool)dr["IsFirstUpdateRank"]
            };
        }

        public bool AddRingstationBattleField(RingstationBattleFieldInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[7]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@DareFlag", (object) info.DareFlag),
          new SqlParameter("@UserName", (object) info.UserName),
          new SqlParameter("@SuccessFlag", (object) info.SuccessFlag),
          new SqlParameter("@Level", (object) info.Level),
          new SqlParameter("@BattleTime", (object) info.BattleTime)
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                flag = this.db.RunProcedure("SP_Ringstation_Battle_Field_Add", SqlParameters);
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Ringstation_Battle_Field_Add", ex);
            }
            return flag;
        }

        public RingstationBattleFieldInfo[] GetAllRingstationBattleFieldByID(int ID)
        {
            List<RingstationBattleFieldInfo> ringstationBattleFieldInfoList = new List<RingstationBattleFieldInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)ID;
                this.db.GetReader(ref ResultDataReader, "SP_Ringstation_Battle_Field_Single", SqlParameters);
                while (ResultDataReader.Read())
                    ringstationBattleFieldInfoList.Add(this.InitRingstationBattleFieldInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitRingstationBattleFieldInfo Single", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return ringstationBattleFieldInfoList.ToArray();
        }

        public RingstationBattleFieldInfo[] GetAllRingstationBattleField()
        {
            List<RingstationBattleFieldInfo> ringstationBattleFieldInfoList = new List<RingstationBattleFieldInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Ringstation_Battle_Field_All");
                while (ResultDataReader.Read())
                    ringstationBattleFieldInfoList.Add(this.InitRingstationBattleFieldInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitRingstationBattleFieldInfo All", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return ringstationBattleFieldInfoList.ToArray();
        }

        public RingstationBattleFieldInfo InitRingstationBattleFieldInfo(SqlDataReader dr)
        {
            return new RingstationBattleFieldInfo()
            {
                ID = (int)dr["ID"],
                UserID = (int)dr["UserID"],
                DareFlag = (bool)dr["DareFlag"],
                UserName = dr["UserName"] == null ? "" : dr["UserName"].ToString(),
                SuccessFlag = (bool)dr["SuccessFlag"],
                Level = (int)dr["Level"],
                BattleTime = (DateTime)dr["BattleTime"]
            };
        }

        public bool AddUserRingStation(UserRingStationInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[13]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@Rank", (object) info.Rank),
          new SqlParameter("@WeaponID", (object) info.WeaponID),
          new SqlParameter("@signMsg", (object) info.signMsg),
          new SqlParameter("@ChallengeNum", (object) info.ChallengeNum),
          new SqlParameter("@buyCount", (object) info.buyCount),
          new SqlParameter("@Total", (object) info.Total),
          new SqlParameter("@ChallengeTime", (object) info.ChallengeTime),
          new SqlParameter("@LastDate", (object) info.LastDate),
          new SqlParameter("@BaseDamage", (object) info.BaseDamage),
          new SqlParameter("@BaseGuard", (object) info.BaseGuard),
          new SqlParameter("@BaseEnergy", (object) info.BaseEnergy)
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                flag = this.db.RunProcedure("SP_Sys_User_RingStation_Add", SqlParameters);
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Sys_User_RingStation_Add", ex);
            }
            return flag;
        }

        public bool UpdateUserRingStation(UserRingStationInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Sys_User_RingStation_Update", new SqlParameter[13]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@Rank", (object) info.Rank),
          new SqlParameter("@WeaponID", (object) info.WeaponID),
          new SqlParameter("@signMsg", (object) info.signMsg),
          new SqlParameter("@ChallengeNum", (object) info.ChallengeNum),
          new SqlParameter("@buyCount", (object) info.buyCount),
          new SqlParameter("@Total", (object) info.Total),
          new SqlParameter("@ChallengeTime", (object) info.ChallengeTime),
          new SqlParameter("@LastDate", (object) info.LastDate),
          new SqlParameter("@BaseDamage", (object) info.BaseDamage),
          new SqlParameter("@BaseGuard", (object) info.BaseGuard),
          new SqlParameter("@BaseEnergy", (object) info.BaseEnergy)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Sys_User_RingStation_Update", ex);
            }
            return flag;
        }

        public UserRingStationInfo GetAllUserRingStationByID(int ID)
        {
            List<UserRingStationInfo> userRingStationInfoList = new List<UserRingStationInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)ID;
                this.db.GetReader(ref ResultDataReader, "SP_Sys_User_RingStation_Single", SqlParameters);
                while (ResultDataReader.Read())
                    userRingStationInfoList.Add(this.InitUserRingStationInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Sys_User_RingStation_Single", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (UserRingStationInfo)null;
        }

        public UserRingStationInfo[] GetAllUserRingStation()
        {
            List<UserRingStationInfo> userRingStationInfoList = new List<UserRingStationInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Sys_User_RingStation_All");
                while (ResultDataReader.Read())
                    userRingStationInfoList.Add(this.InitUserRingStationInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Sys_User_RingStation_All", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return userRingStationInfoList.ToArray();
        }

        public UserRingStationInfo InitUserRingStationInfo(SqlDataReader dr)
        {
            return new UserRingStationInfo()
            {
                ID = (int)dr["ID"],
                UserID = (int)dr["UserID"],
                Rank = (int)dr["Rank"],
                WeaponID = (int)dr["WeaponID"],
                signMsg = dr["signMsg"] == null ? "" : dr["signMsg"].ToString(),
                ChallengeNum = (int)dr["ChallengeNum"],
                buyCount = (int)dr["buyCount"],
                Total = (int)dr["Total"],
                ChallengeTime = (DateTime)dr["ChallengeTime"],
                LastDate = (DateTime)dr["LastDate"],
                BaseDamage = (int)dr["BaseDamage"],
                BaseGuard = (int)dr["BaseGuard"],
                BaseEnergy = (int)dr["BaseEnergy"]
            };
        }

        public bool AddUsersPetForm(UsersPetFormInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@PetsID", (object) info.PetsID),
          new SqlParameter("@ActivePets", (object) info.ActivePets)
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                flag = this.db.RunProcedure("SP_Sys_User_Pet_Form_Add", SqlParameters);
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Sys_User_Pet_Form_Add", ex);
            }
            return flag;
        }

        public bool UpdateUsersPetForm(UsersPetFormInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Sys_User_Pet_Form_Update", new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@PetsID", (object) info.PetsID),
          new SqlParameter("@ActivePets", (object) info.ActivePets)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Sys_User_Pet_Form_Update", ex);
            }
            return flag;
        }

        public UsersPetFormInfo GetAllUsersPetFormByID(int ID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)ID;
                this.db.GetReader(ref ResultDataReader, "SP_Sys_User_Pet_Form_All", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitUsersPetFormInfo(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitUsersPetFormInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (UsersPetFormInfo)null;
        }

        public UsersPetFormInfo InitUsersPetFormInfo(SqlDataReader dr)
        {
            return new UsersPetFormInfo()
            {
                ID = (int)dr["ID"],
                UserID = (int)dr["UserID"],
                PetsID = (int)dr["PetsID"],
                ActivePets = dr["ActivePets"] == null ? "" : dr["ActivePets"].ToString()
            };
        }

        public EatPetsInfo GetAllEatPetsByID(int ID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)ID;
                this.db.GetReader(ref ResultDataReader, "SP_Sys_Eat_Pets_All", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitEatPetsInfo(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitEatPetsInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (EatPetsInfo)null;
        }

        public EatPetsInfo InitEatPetsInfo(SqlDataReader dr)
        {
            return new EatPetsInfo()
            {
                ID = (int)dr["ID"],
                UserID = (int)dr["UserID"],
                weaponExp = (int)dr["weaponExp"],
                weaponLevel = (int)dr["weaponLevel"],
                clothesExp = (int)dr["clothesExp"],
                clothesLevel = (int)dr["clothesLevel"],
                hatExp = (int)dr["hatExp"],
                hatLevel = (int)dr["hatLevel"]
            };
        }

        public bool UpdateEatPets(EatPetsInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Sys_Eat_Pets_Update", new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@weaponExp", (object) info.weaponExp),
          new SqlParameter("@weaponLevel", (object) info.weaponLevel),
          new SqlParameter("@clothesExp", (object) info.clothesExp),
          new SqlParameter("@clothesLevel", (object) info.clothesLevel),
          new SqlParameter("@hatExp", (object) info.hatExp),
          new SqlParameter("@hatLevel", (object) info.hatLevel)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Sys_Eat_Pets_Update", ex);
            }
            return flag;
        }

        public bool AddEatPets(EatPetsInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@weaponExp", (object) info.weaponExp),
          new SqlParameter("@weaponLevel", (object) info.weaponLevel),
          new SqlParameter("@clothesExp", (object) info.clothesExp),
          new SqlParameter("@clothesLevel", (object) info.clothesLevel),
          new SqlParameter("@hatExp", (object) info.hatExp),
          new SqlParameter("@hatLevel", (object) info.hatLevel)
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                flag = this.db.RunProcedure("SP_Sys_Eat_Pets_Add", SqlParameters);
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Sys_Eat_Pets_Add", ex);
            }
            return flag;
        }

        public bool AddUsersMagicHouse(UsersMagicHouseInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[16]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@isOpen", (object) info.isOpen),
          new SqlParameter("@isMagicRoomShow", (object) info.isMagicRoomShow),
          new SqlParameter("@magicJuniorLv", (object) info.magicJuniorLv),
          new SqlParameter("@magicJuniorExp", (object) info.magicJuniorExp),
          new SqlParameter("@magicMidLv", (object) info.magicMidLv),
          new SqlParameter("@magicMidExp", (object) info.magicMidExp),
          new SqlParameter("@magicSeniorLv", (object) info.magicSeniorLv),
          new SqlParameter("@magicSeniorExp", (object) info.magicSeniorExp),
          new SqlParameter("@freeGetCount", (object) info.freeGetCount),
          new SqlParameter("@freeGetTime", (object) info.freeGetTime),
          new SqlParameter("@chargeGetCount", (object) info.chargeGetCount),
          new SqlParameter("@chargeGetTime", (object) info.chargeGetTime),
          new SqlParameter("@depotCount", (object) info.depotCount),
          new SqlParameter("@activityWeapons", (object) info.activityWeapons)
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                flag = this.db.RunProcedure("SP_Sys_User_MagicHouse_Add", SqlParameters);
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Sys_User_MagicHouse_Add", ex);
            }
            return flag;
        }

        public bool UpdateUsersMagicHouse(UsersMagicHouseInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Sys_User_MagicHouse_Update", new SqlParameter[15]
                {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@isOpen", (object) info.isOpen),
          new SqlParameter("@isMagicRoomShow", (object) info.isMagicRoomShow),
          new SqlParameter("@magicJuniorLv", (object) info.magicJuniorLv),
          new SqlParameter("@magicJuniorExp", (object) info.magicJuniorExp),
          new SqlParameter("@magicMidLv", (object) info.magicMidLv),
          new SqlParameter("@magicMidExp", (object) info.magicMidExp),
          new SqlParameter("@magicSeniorLv", (object) info.magicSeniorLv),
          new SqlParameter("@magicSeniorExp", (object) info.magicSeniorExp),
          new SqlParameter("@freeGetCount", (object) info.freeGetCount),
          new SqlParameter("@freeGetTime", (object) info.freeGetTime),
          new SqlParameter("@chargeGetCount", (object) info.chargeGetCount),
          new SqlParameter("@chargeGetTime", (object) info.chargeGetTime),
          new SqlParameter("@depotCount", (object) info.depotCount),
          new SqlParameter("@activityWeapons", (object) info.activityWeapons)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Sys_User_MagicHouse_Update", ex);
            }
            return flag;
        }

        public UsersMagicHouseInfo GetAllUsersMagicHouseByID(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Sys_User_MagicHouse_Single", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitUsersMagicHouseInfo(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitUsersMagicHouseInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (UsersMagicHouseInfo)null;
        }

        public UsersMagicHouseInfo InitUsersMagicHouseInfo(SqlDataReader dr)
        {
            return new UsersMagicHouseInfo()
            {
                ID = (int)dr["ID"],
                UserID = (int)dr["UserID"],
                isOpen = (bool)dr["isOpen"],
                isMagicRoomShow = (bool)dr["isMagicRoomShow"],
                magicJuniorLv = (int)dr["magicJuniorLv"],
                magicJuniorExp = (int)dr["magicJuniorExp"],
                magicMidLv = (int)dr["magicMidLv"],
                magicMidExp = (int)dr["magicMidExp"],
                magicSeniorLv = (int)dr["magicSeniorLv"],
                magicSeniorExp = (int)dr["magicSeniorExp"],
                freeGetCount = (int)dr["freeGetCount"],
                freeGetTime = (DateTime)dr["freeGetTime"],
                chargeGetCount = (int)dr["chargeGetCount"],
                chargeGetTime = (DateTime)dr["chargeGetTime"],
                depotCount = (int)dr["depotCount"],
                activityWeapons = dr["activityWeapons"] == null ? "" : dr["activityWeapons"].ToString()
            };
        }

        public PetFormDataInfo[] GetAllPetFormData()
        {
            List<PetFormDataInfo> petFormDataInfoList = new List<PetFormDataInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Pet_Form_Data_All");
                while (ResultDataReader.Read())
                    petFormDataInfoList.Add(this.InitPetFormDataInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitPetFormDataInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return petFormDataInfoList.ToArray();
        }

        public PetFormDataInfo InitPetFormDataInfo(SqlDataReader dr)
        {
            return new PetFormDataInfo()
            {
                Appearance = (string)dr["Appearance"],
                DamageReduce = (int)dr["DamageReduce"],
                HeathUp = (int)dr["HeathUp"],
                Name = (string)dr["Name"],
                Resource = (string)dr["Resource"],
                TemplateID = (int)dr["TemplateID"]
            };
        }

        public DiceDataInfo GetSingleDiceData(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_GetSingle_DiceData", SqlParameters);
                if (ResultDataReader.Read())
                    return new DiceDataInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        UserID = (int)ResultDataReader[nameof(UserID)],
                        LuckIntegral = (int)ResultDataReader["LuckIntegral"],
                        LuckIntegralLevel = (int)ResultDataReader["LuckIntegralLevel"],
                        Level = (int)ResultDataReader["Level"],
                        FreeCount = (int)ResultDataReader["FreeCount"],
                        CurrentPosition = (int)ResultDataReader["CurrentPosition"],
                        UserFirstCell = (bool)ResultDataReader["UserFirstCell"],
                        AwardArray = ResultDataReader["AwardArray"] == null ? "" : ResultDataReader["AwardArray"].ToString()
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_GetSingleDiceData", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (DiceDataInfo)null;
        }

        public bool AddDiceData(DiceDataInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[10];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)info.UserID);
                SqlParameters[2] = new SqlParameter("@LuckIntegral", (object)info.LuckIntegral);
                SqlParameters[3] = new SqlParameter("@LuckIntegralLevel", (object)info.LuckIntegralLevel);
                SqlParameters[4] = new SqlParameter("@Level", (object)info.Level);
                SqlParameters[5] = new SqlParameter("@FreeCount", (object)info.FreeCount);
                SqlParameters[6] = new SqlParameter("@CurrentPosition", (object)info.CurrentPosition);
                SqlParameters[7] = new SqlParameter("@UserFirstCell", (object)info.UserFirstCell);
                SqlParameters[8] = new SqlParameter("@AwardArray", (object)info.AwardArray);
                SqlParameters[9] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[9].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_DiceData_Add", SqlParameters);
                flag = (int)SqlParameters[9].Value == 0;
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_DiceData_Add", ex);
            }
            return flag;
        }

        public bool UpdateDiceData(DiceDataInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[10]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@LuckIntegral", (object) info.LuckIntegral),
          new SqlParameter("@LuckIntegralLevel", (object) info.LuckIntegralLevel),
          new SqlParameter("@Level", (object) info.Level),
          new SqlParameter("@FreeCount", (object) info.FreeCount),
          new SqlParameter("@CurrentPosition", (object) info.CurrentPosition),
          new SqlParameter("@UserFirstCell", (object) info.UserFirstCell),
          new SqlParameter("@AwardArray", (object) info.AwardArray),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[9].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Update_DiceData", SqlParameters);
                flag = (int)SqlParameters[9].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Update_DiceData", ex);
            }
            return flag;
        }

        public SubActiveInfo[] GetAllSubActive()
        {
            List<SubActiveInfo> subActiveInfoList = new List<SubActiveInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_SubActive_All");
                while (ResultDataReader.Read())
                    subActiveInfoList.Add(new SubActiveInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        ActiveID = (int)ResultDataReader["ActiveID"],
                        SubID = (int)ResultDataReader["SubID"],
                        IsOpen = (bool)ResultDataReader["IsOpen"],
                        StartDate = (DateTime)ResultDataReader["StartDate"],
                        StartTime = (DateTime)ResultDataReader["StartTime"],
                        EndDate = (DateTime)ResultDataReader["EndDate"],
                        EndTime = (DateTime)ResultDataReader["EndTime"],
                        IsContinued = (bool)ResultDataReader["IsContinued"],
                        ActiveInfo = ResultDataReader["ActiveInfo"] == null ? "" : ResultDataReader["ActiveInfo"].ToString()
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init AllSubActive", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return subActiveInfoList.ToArray();
        }

        public SubActiveConditionInfo[] GetAllSubActiveCondition(int ActiveID)
        {
            List<SubActiveConditionInfo> activeConditionInfoList = new List<SubActiveConditionInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ActiveID", (object) ActiveID)
                };
                this.db.GetReader(ref ResultDataReader, "SP_SubActiveCondition_All", SqlParameters);
                while (ResultDataReader.Read())
                    activeConditionInfoList.Add(new SubActiveConditionInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        ActiveID = (int)ResultDataReader[nameof(ActiveID)],
                        SubID = (int)ResultDataReader["SubID"],
                        ConditionID = (int)ResultDataReader["ConditionID"],
                        Type = (int)ResultDataReader["Type"],
                        Value = ResultDataReader["Value"] == null ? "" : ResultDataReader["Value"].ToString(),
                        AwardType = (int)ResultDataReader["AwardType"],
                        AwardValue = ResultDataReader["AwardValue"] == null ? "" : ResultDataReader["AwardValue"].ToString(),
                        IsValid = (bool)ResultDataReader["IsValid"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init AllSubActive", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return activeConditionInfoList.ToArray();
        }

        public bool AddStore(SqlDataProvider.Data.ItemInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[14];
                SqlParameters[0] = new SqlParameter("@ItemID", (object)item.ItemID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)item.UserID);
                SqlParameters[2] = new SqlParameter("@TemplateID", (object)item.Template.TemplateID);
                SqlParameters[3] = new SqlParameter("@Place", (object)item.Place);
                SqlParameters[4] = new SqlParameter("@AgilityCompose", (object)item.AgilityCompose);
                SqlParameters[5] = new SqlParameter("@AttackCompose", (object)item.AttackCompose);
                SqlParameters[6] = new SqlParameter("@BeginDate", (object)item.BeginDate);
                SqlParameters[7] = new SqlParameter("@Color", item.Color == null ? (object)"" : (object)item.Color);
                SqlParameters[8] = new SqlParameter("@Count", (object)item.Count);
                SqlParameters[9] = new SqlParameter("@DefendCompose", (object)item.DefendCompose);
                SqlParameters[10] = new SqlParameter("@IsBinds", (object)item.IsBinds);
                SqlParameters[11] = new SqlParameter("@IsExist", (object)item.IsExist);
                SqlParameters[12] = new SqlParameter("@IsJudge", (object)item.IsJudge);
                SqlParameters[13] = new SqlParameter("@LuckCompose", (object)item.LuckCompose);
                flag = this.db.RunProcedure("SP_Users_Items_Add", SqlParameters);
                item.ItemID = (int)SqlParameters[0].Value;
                item.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpateStore(SqlDataProvider.Data.ItemInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[14];
                SqlParameters[0] = new SqlParameter("@ItemID", (object)item.ItemID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)item.UserID);
                SqlParameters[2] = new SqlParameter("@TemplateID", (object)item.Template.TemplateID);
                SqlParameters[3] = new SqlParameter("@Place", (object)item.Place);
                SqlParameters[4] = new SqlParameter("@AgilityCompose", (object)item.AgilityCompose);
                SqlParameters[5] = new SqlParameter("@AttackCompose", (object)item.AttackCompose);
                SqlParameters[6] = new SqlParameter("@BeginDate", (object)item.BeginDate);
                SqlParameters[7] = new SqlParameter("@Color", item.Color == null ? (object)"" : (object)item.Color);
                SqlParameters[8] = new SqlParameter("@Count", (object)item.Count);
                SqlParameters[9] = new SqlParameter("@DefendCompose", (object)item.DefendCompose);
                SqlParameters[10] = new SqlParameter("@IsBinds", (object)item.IsBinds);
                SqlParameters[11] = new SqlParameter("@IsExist", (object)item.IsExist);
                SqlParameters[12] = new SqlParameter("@IsJudge", (object)item.IsJudge);
                SqlParameters[13] = new SqlParameter("@LuckCompose", (object)item.LuckCompose);
                flag = this.db.RunProcedure("SP_Users_Items_Add", SqlParameters);
                item.ItemID = (int)SqlParameters[0].Value;
                item.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateBuyStore(int storeId)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Update_Buy_Store", new SqlParameter[1]
                {
          new SqlParameter("@StoreID", (object) storeId)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Update_Buy_Store", ex);
            }
            return flag;
        }

        public ConsortiaUserInfo[] GetAllMemberByConsortia(int ConsortiaID)
        {
            List<ConsortiaUserInfo> consortiaUserInfoList = new List<ConsortiaUserInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ConsortiaID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)ConsortiaID;
                this.db.GetReader(ref ResultDataReader, "SP_Consortia_Users_All", SqlParameters);
                while (ResultDataReader.Read())
                    consortiaUserInfoList.Add(this.InitConsortiaUserInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return consortiaUserInfoList.ToArray();
        }

        public ConsortiaUserInfo InitConsortiaUserInfo(SqlDataReader dr)
        {
            ConsortiaUserInfo consortiaUserInfo = new ConsortiaUserInfo()
            {
                ID = (int)dr["ID"],
                ConsortiaID = (int)dr["ConsortiaID"],
                DutyID = (int)dr["DutyID"],
                DutyName = dr["DutyName"].ToString(),
                IsExist = (bool)dr["IsExist"],
                RatifierID = (int)dr["RatifierID"],
                RatifierName = dr["RatifierName"].ToString(),
                Remark = dr["Remark"].ToString(),
                UserID = (int)dr["UserID"],
                UserName = dr["UserName"].ToString(),
                Grade = (int)dr["Grade"],
                GP = (int)dr["GP"],
                Repute = (int)dr["Repute"],
                State = (int)dr["State"],
                Right = (int)dr["Right"],
                Offer = (int)dr["Offer"],
                Colors = dr["Colors"].ToString(),
                Style = dr["Style"].ToString(),
                Hide = (int)dr["Hide"]
            };
            consortiaUserInfo.Skin = dr["Skin"] == null ? "" : consortiaUserInfo.Skin;
            consortiaUserInfo.Level = (int)dr["Level"];
            consortiaUserInfo.LastDate = (DateTime)dr["LastDate"];
            consortiaUserInfo.Sex = (bool)dr["Sex"];
            consortiaUserInfo.IsBanChat = (bool)dr["IsBanChat"];
            consortiaUserInfo.Win = (int)dr["Win"];
            consortiaUserInfo.Total = (int)dr["Total"];
            consortiaUserInfo.Escape = (int)dr["Escape"];
            consortiaUserInfo.RichesOffer = (int)dr["RichesOffer"];
            consortiaUserInfo.RichesRob = (int)dr["RichesRob"];
            consortiaUserInfo.LoginName = dr["LoginName"] == null ? "" : dr["LoginName"].ToString();
            consortiaUserInfo.Nimbus = (int)dr["Nimbus"];
            consortiaUserInfo.FightPower = (int)dr["FightPower"];
            consortiaUserInfo.typeVIP = Convert.ToByte(dr["typeVIP"]);
            consortiaUserInfo.VIPLevel = (int)dr["VIPLevel"];
            return consortiaUserInfo;
        }

        public bool ActivePlayer(
          ref PlayerInfo player,
          string userName,
          string passWord,
          bool sex,
          int gold,
          int money,
          string IP,
          string site)
        {
            bool flag = false;
            try
            {
                player = new PlayerInfo();
                player.Agility = 0;
                player.Attack = 0;
                player.Colors = ",,,,,,";
                player.Skin = "";
                player.ConsortiaID = 0;
                player.Defence = 0;
                player.Gold = 0;
                player.GP = 1;
                player.Grade = 1;
                player.ID = 0;
                player.Luck = 0;
                player.Money = 0;
                player.NickName = "";
                player.Sex = sex;
                player.State = 0;
                player.Style = ",,,,,,";
                player.Hide = 1111111111;
                SqlParameter[] SqlParameters = new SqlParameter[21];
                SqlParameters[0] = new SqlParameter("@UserID", SqlDbType.Int);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Attack", (object)player.Attack);
                SqlParameters[2] = new SqlParameter("@Colors", player.Colors == null ? (object)"" : (object)player.Colors);
                SqlParameters[3] = new SqlParameter("@ConsortiaID", (object)player.ConsortiaID);
                SqlParameters[4] = new SqlParameter("@Defence", (object)player.Defence);
                SqlParameters[5] = new SqlParameter("@Gold", (object)player.Gold);
                SqlParameters[6] = new SqlParameter("@GP", (object)player.GP);
                SqlParameters[7] = new SqlParameter("@Grade", (object)player.Grade);
                SqlParameters[8] = new SqlParameter("@Luck", (object)player.Luck);
                SqlParameters[9] = new SqlParameter("@Money", (object)player.Money);
                SqlParameters[10] = new SqlParameter("@Style", player.Style == null ? (object)"" : (object)player.Style);
                SqlParameters[11] = new SqlParameter("@Agility", (object)player.Agility);
                SqlParameters[12] = new SqlParameter("@State", (object)player.State);
                SqlParameters[13] = new SqlParameter("@UserName", (object)userName);
                SqlParameters[14] = new SqlParameter("@PassWord", (object)passWord);
                SqlParameters[15] = new SqlParameter("@Sex", (object)sex);
                SqlParameters[16] = new SqlParameter("@Hide", (object)player.Hide);
                SqlParameters[17] = new SqlParameter("@ActiveIP", (object)IP);
                SqlParameters[18] = new SqlParameter("@Skin", player.Skin == null ? (object)"" : (object)player.Skin);
                SqlParameters[19] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[19].Direction = ParameterDirection.ReturnValue;
                SqlParameters[20] = new SqlParameter("@Site", (object)site);
                flag = this.db.RunProcedure("SP_Users_Active", SqlParameters);
                player.ID = (int)SqlParameters[0].Value;
                flag = (int)SqlParameters[19].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool RegisterPlayer(
          string userName,
          string passWord,
          string nickName,
          string bStyle,
          string gStyle,
          string armColor,
          string hairColor,
          string faceColor,
          string clothColor,
          string hatColor,
          int sex,
          ref string msg,
          int validDate)
        {
            bool flag = false;
            try
            {
                string[] strArray1 = bStyle.Split(',');
                string[] strArray2 = gStyle.Split(',');
                SqlParameter[] SqlParameters = new SqlParameter[21]
                {
          new SqlParameter("@UserName", (object) userName),
          new SqlParameter("@PassWord", (object) passWord),
          new SqlParameter("@NickName", (object) nickName),
          new SqlParameter("@BArmID", (object) int.Parse(strArray1[0])),
          new SqlParameter("@BHairID", (object) int.Parse(strArray1[1])),
          new SqlParameter("@BFaceID", (object) int.Parse(strArray1[2])),
          new SqlParameter("@BClothID", (object) int.Parse(strArray1[3])),
          new SqlParameter("@BHatID", (object) int.Parse(strArray1[4])),
          new SqlParameter("@GArmID", (object) int.Parse(strArray2[0])),
          new SqlParameter("@GHairID", (object) int.Parse(strArray2[1])),
          new SqlParameter("@GFaceID", (object) int.Parse(strArray2[2])),
          new SqlParameter("@GClothID", (object) int.Parse(strArray2[3])),
          new SqlParameter("@GHatID", (object) int.Parse(strArray2[4])),
          new SqlParameter("@ArmColor", (object) armColor),
          new SqlParameter("@HairColor", (object) hairColor),
          new SqlParameter("@FaceColor", (object) faceColor),
          new SqlParameter("@ClothColor", (object) clothColor),
          new SqlParameter("@HatColor", (object) clothColor),
          new SqlParameter("@Sex", (object) sex),
          new SqlParameter("@StyleDate", (object) validDate),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[20].Direction = ParameterDirection.ReturnValue;
                flag = this.db.RunProcedure("SP_Users_RegisterNotValidate", SqlParameters);
                int num = (int)SqlParameters[20].Value;
                flag = num == 0;
                switch (num)
                {
                    case 2:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.RegisterPlayer.Msg2");
                        break;
                    case 3:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.RegisterPlayer.Msg3");
                        break;
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool RenameNick(string userName, string nickName, string newNickName, ref string msg)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[4]
                {
          new SqlParameter("@UserName", (object) userName),
          new SqlParameter("@NickName", (object) nickName),
          new SqlParameter("@NewNickName", (object) newNickName),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[3].Direction = ParameterDirection.ReturnValue;
                flag = this.db.RunProcedure("SP_Users_RenameNick", SqlParameters);
                int num = (int)SqlParameters[3].Value;
                flag = num == 0;
                switch (num)
                {
                    case 4:
                    case 5:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.RenameNick.Msg4");
                        break;
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(RenameNick), ex);
            }
            return flag;
        }

        public bool ChangeSex(int UserId, bool newSex)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[3]
                {
          new SqlParameter("@UserId", (object) UserId),
          new SqlParameter("@Sex", (object) newSex),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[2].Direction = ParameterDirection.ReturnValue;
                flag = this.db.RunProcedure("SP_Users_ChangSexByCard", SqlParameters);
                flag = (int)SqlParameters[2].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Users_ChangSexByCard ", ex);
            }
            return flag;
        }

        public bool RenameNick(string userName, string nickName, string newNickName)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[4]
                {
          new SqlParameter("@UserName", (object) userName),
          new SqlParameter("@NickName", (object) nickName),
          new SqlParameter("@NewNickName", (object) newNickName),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[3].Direction = ParameterDirection.ReturnValue;
                flag = this.db.RunProcedure("SP_Users_RenameByCard", SqlParameters);
                flag = (int)SqlParameters[3].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(RenameNick), ex);
            }
            return flag;
        }

        public bool DisableUser(string userName, bool isExit)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[3]
                {
          new SqlParameter("@UserName", (object) userName),
          new SqlParameter("@IsExist", (object) isExit),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[2].Direction = ParameterDirection.ReturnValue;
                flag = this.db.RunProcedure("SP_Disable_User", SqlParameters);
                if ((int)SqlParameters[2].Value == 0)
                    flag = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(DisableUser), ex);
            }
            return flag;
        }

        public bool UpdatePassWord(int userID, string password)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Users_UpdatePassword", new SqlParameter[2]
                {
          new SqlParameter("@UserID", (object) userID),
          new SqlParameter("@Password", (object) password)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdatePasswordInfo(
          int userID,
          string PasswordQuestion1,
          string PasswordAnswer1,
          string PasswordQuestion2,
          string PasswordAnswer2,
          int Count)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Users_Password_Add", new SqlParameter[6]
                {
          new SqlParameter("@UserID", (object) userID),
          new SqlParameter("@PasswordQuestion1", (object) PasswordQuestion1),
          new SqlParameter("@PasswordAnswer1", (object) PasswordAnswer1),
          new SqlParameter("@PasswordQuestion2", (object) PasswordQuestion2),
          new SqlParameter("@PasswordAnswer2", (object) PasswordAnswer2),
          new SqlParameter("@FailedPasswordAttemptCount", (object) Count)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public void GetPasswordInfo(
          int userID,
          ref string PasswordQuestion1,
          ref string PasswordAnswer1,
          ref string PasswordQuestion2,
          ref string PasswordAnswer2,
          ref int Count)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", (object) userID)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Users_PasswordInfo", SqlParameters);
                while (ResultDataReader.Read())
                {
                    PasswordQuestion1 = ResultDataReader[nameof(PasswordQuestion1)] == null ? "" : ResultDataReader[nameof(PasswordQuestion1)].ToString();
                    PasswordAnswer1 = ResultDataReader[nameof(PasswordAnswer1)] == null ? "" : ResultDataReader[nameof(PasswordAnswer1)].ToString();
                    PasswordQuestion2 = ResultDataReader[nameof(PasswordQuestion2)] == null ? "" : ResultDataReader[nameof(PasswordQuestion2)].ToString();
                    PasswordAnswer2 = ResultDataReader[nameof(PasswordAnswer2)] == null ? "" : ResultDataReader[nameof(PasswordAnswer2)].ToString();
                    Count = !((DateTime)ResultDataReader["LastFindDate"] == DateTime.Today) ? 5 : (int)ResultDataReader["FailedPasswordAttemptCount"];
                }
            }
            catch (Exception ex)
            {
                if (!BaseBussiness.log.IsErrorEnabled)
                    return;
                BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
        }

        public bool UpdatePasswordTwo(int userID, string passwordTwo)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Users_UpdatePasswordTwo", new SqlParameter[2]
                {
          new SqlParameter("@UserID", (object) userID),
          new SqlParameter("@PasswordTwo", (object) passwordTwo)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public PlayerInfo[] GetUserLoginList(string userName)
        {
            List<PlayerInfo> playerInfoList = new List<PlayerInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserName", SqlDbType.NVarChar, 200)
                };
                SqlParameters[0].Value = (object)userName;
                this.db.GetReader(ref ResultDataReader, "SP_Users_LoginList", SqlParameters);
                while (ResultDataReader.Read())
                    playerInfoList.Add(this.InitPlayerInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return playerInfoList.ToArray();
        }

        public PlayerInfo LoginGame(
          string username,
          ref int isFirst,
          ref bool isExist,
          ref bool isError,
          bool firstValidate,
          ref DateTime forbidDate,
          string nickname)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[4]
                {
          new SqlParameter("@UserName", (object) username),
          new SqlParameter("@Password", (object) ""),
          new SqlParameter("@FirstValidate", (object) firstValidate),
          new SqlParameter("@Nickname", (object) nickname)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Users_LoginWeb", SqlParameters);
                if (ResultDataReader.Read())
                {
                    isFirst = (int)ResultDataReader["IsFirst"];
                    isExist = (bool)ResultDataReader["IsExist"];
                    forbidDate = (DateTime)ResultDataReader["ForbidDate"];
                    if (isFirst > 1)
                        --isFirst;
                    return this.InitPlayerInfo(ResultDataReader);
                }
            }
            catch (Exception ex)
            {
                isError = true;
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (PlayerInfo)null;
        }

        public PlayerInfo LoginGame(string username, string password)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
          new SqlParameter("@UserName", (object) username),
          new SqlParameter("@Password", (object) password)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Users_Login", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitPlayerInfo(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (PlayerInfo)null;
        }

        public PlayerInfo ReLoadPlayer(int ID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) ID)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Users_Reload", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitPlayerInfo(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (PlayerInfo)null;
        }

        public bool UpdatePlayer(PlayerInfo player)
        {
            bool flag = false;
            try
            {
                if (player.Grade < 1)
                    return flag;
                SqlParameter[] SqlParameters = new SqlParameter[90];
                SqlParameters[0] = new SqlParameter("@UserID", (object)player.ID);
                SqlParameters[1] = new SqlParameter("@Attack", (object)player.Attack);
                SqlParameters[2] = new SqlParameter("@Colors", player.Colors == null ? (object)"" : (object)player.Colors);
                SqlParameters[3] = new SqlParameter("@ConsortiaID", (object)player.ConsortiaID);
                SqlParameters[4] = new SqlParameter("@Defence", (object)player.Defence);
                SqlParameters[5] = new SqlParameter("@Gold", (object)player.Gold);
                SqlParameters[6] = new SqlParameter("@GP", (object)player.GP);
                SqlParameters[7] = new SqlParameter("@Grade", (object)player.Grade);
                SqlParameters[8] = new SqlParameter("@Luck", (object)player.Luck);
                SqlParameters[9] = new SqlParameter("@Money", (object)player.Money);
                SqlParameters[10] = new SqlParameter("@Style", player.Style == null ? (object)"" : (object)player.Style);
                SqlParameters[11] = new SqlParameter("@Agility", (object)player.Agility);
                SqlParameters[12] = new SqlParameter("@State", (object)player.State);
                SqlParameters[13] = new SqlParameter("@Hide", (object)player.Hide);
                SqlParameters[14] = new SqlParameter("@ExpendDate", !player.ExpendDate.HasValue ? (object)"" : (object)player.ExpendDate.ToString());
                SqlParameters[15] = new SqlParameter("@Win", (object)player.Win);
                SqlParameters[16] = new SqlParameter("@Total", (object)player.Total);
                SqlParameters[17] = new SqlParameter("@Escape", (object)player.Escape);
                SqlParameters[18] = new SqlParameter("@Skin", player.Skin == null ? (object)"" : (object)player.Skin);
                SqlParameters[19] = new SqlParameter("@Offer", (object)player.Offer);
                SqlParameters[20] = new SqlParameter("@AntiAddiction", (object)player.AntiAddiction);
                SqlParameters[20].Direction = ParameterDirection.InputOutput;
                SqlParameters[21] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[21].Direction = ParameterDirection.ReturnValue;
                SqlParameters[22] = new SqlParameter("@RichesOffer", (object)player.RichesOffer);
                SqlParameters[23] = new SqlParameter("@RichesRob", (object)player.RichesRob);
                SqlParameters[24] = new SqlParameter("@CheckCount", (object)player.CheckCount);
                SqlParameters[24].Direction = ParameterDirection.InputOutput;
                SqlParameters[25] = new SqlParameter("@MarryInfoID", (object)player.MarryInfoID);
                SqlParameters[26] = new SqlParameter("@DayLoginCount", (object)player.DayLoginCount);
                SqlParameters[27] = new SqlParameter("@Nimbus", (object)player.Nimbus);
                SqlParameters[28] = new SqlParameter("@LastAward", (object)player.LastAward);
                SqlParameters[29] = new SqlParameter("@GiftToken", (object)player.DDTMoney);
                SqlParameters[30] = new SqlParameter("@QuestSite", (object)player.QuestSite);
                SqlParameters[31] = new SqlParameter("@PvePermission", (object)player.PvePermission);
                SqlParameters[32] = new SqlParameter("@FightPower", (object)player.FightPower);
                SqlParameters[33] = new SqlParameter("@AnswerSite", (object)player.AnswerSite);
                SqlParameters[34] = new SqlParameter("@LastAuncherAward", (object)player.LastAward);
                SqlParameters[35] = new SqlParameter("@hp", (object)player.hp);
                SqlParameters[36] = new SqlParameter("@ChatCount", (object)player.ChatCount);
                SqlParameters[37] = new SqlParameter("@SpaPubGoldRoomLimit", (object)player.SpaPubGoldRoomLimit);
                SqlParameters[38] = new SqlParameter("@LastSpaDate", (object)player.LastSpaDate);
                SqlParameters[39] = new SqlParameter("@FightLabPermission", (object)player.FightLabPermission);
                SqlParameters[40] = new SqlParameter("@SpaPubMoneyRoomLimit", (object)player.SpaPubMoneyRoomLimit);
                SqlParameters[41] = new SqlParameter("@IsInSpaPubGoldToday", (object)player.IsInSpaPubGoldToday);
                SqlParameters[42] = new SqlParameter("@IsInSpaPubMoneyToday", (object)player.IsInSpaPubMoneyToday);
                SqlParameters[43] = new SqlParameter("@AchievementPoint", (object)player.AchievementPoint);
                SqlParameters[44] = new SqlParameter("@LastWeekly", (object)player.LastWeekly);
                SqlParameters[45] = new SqlParameter("@LastWeeklyVersion", (object)player.LastWeeklyVersion);
                SqlParameters[46] = new SqlParameter("@GiftGp", (object)player.GiftGp);
                SqlParameters[47] = new SqlParameter("@GiftLevel", (object)player.GiftLevel);
                SqlParameters[48] = new SqlParameter("@IsOpenGift", (object)player.IsOpenGift);
                SqlParameters[49] = new SqlParameter("@WeaklessGuildProgressStr", (object)player.WeaklessGuildProgressStr);
                SqlParameters[50] = new SqlParameter("@IsOldPlayer", (object)player.IsOldPlayer);
                SqlParameters[51] = new SqlParameter("@VIPLevel", (object)player.VIPLevel);
                SqlParameters[52] = new SqlParameter("@VIPExp", (object)player.VIPExp);
                SqlParameters[53] = new SqlParameter("@Score", (object)player.Score);
                SqlParameters[54] = new SqlParameter("@OptionOnOff", (object)player.OptionOnOff);
                SqlParameters[55] = new SqlParameter("@isOldPlayerHasValidEquitAtLogin", (object)player.isOldPlayerHasValidEquitAtLogin);
                SqlParameters[56] = new SqlParameter("@badLuckNumber", (object)player.badLuckNumber);
                SqlParameters[57] = new SqlParameter("@luckyNum", (object)player.luckyNum);
                SqlParameters[58] = new SqlParameter("@lastLuckyNumDate", (object)player.lastLuckyNumDate.ToString());
                SqlParameters[59] = new SqlParameter("@lastLuckNum", (object)player.lastLuckNum);
                SqlParameters[60] = new SqlParameter("@CardSoul", (object)player.CardSoul);
                SqlParameters[61] = new SqlParameter("@uesedFinishTime", (object)player.uesedFinishTime);
                SqlParameters[62] = new SqlParameter("@totemId", (object)player.totemId);
                SqlParameters[63] = new SqlParameter("@damageScores", (object)player.damageScores);
                SqlParameters[64] = new SqlParameter("@petScore", (object)player.petScore);
                SqlParameters[65] = new SqlParameter("@IsShowConsortia", (object)player.IsShowConsortia);
                SqlParameters[66] = new SqlParameter("@LastRefreshPet", (object)player.LastRefreshPet.ToString());
                SqlParameters[67] = new SqlParameter("@GetSoulCount", (object)player.GetSoulCount);
                SqlParameters[68] = new SqlParameter("@isFirstDivorce", (object)player.isFirstDivorce);
                SqlParameters[69] = new SqlParameter("@needGetBoxTime", (object)player.needGetBoxTime);
                SqlParameters[70] = new SqlParameter("@myScore", (object)player.myScore);
                SqlParameters[71] = new SqlParameter("@TimeBox", (object)player.TimeBox.ToString());
                SqlParameters[72] = new SqlParameter("@IsFistGetPet", (object)player.IsFistGetPet);
                SqlParameters[73] = new SqlParameter("@MaxBuyHonor", (object)player.MaxBuyHonor);
                SqlParameters[74] = new SqlParameter("@Medal", (object)player.medal);
                SqlParameters[75] = new SqlParameter("@myHonor", (object)player.myHonor);
                SqlParameters[76] = new SqlParameter("@LeagueMoney", (object)player.LeagueMoney);
                SqlParameters[77] = new SqlParameter("@Honor", (object)player.Honor);
                SqlParameters[78] = new SqlParameter("@necklaceExp", (object)player.necklaceExp);
                SqlParameters[79] = new SqlParameter("@necklaceExpAdd", (object)player.necklaceExpAdd);
                SqlParameters[80] = new SqlParameter("@hardCurrency", (object)player.hardCurrency);
                SqlParameters[81] = new SqlParameter("@accumulativeLoginDays", (object)player.accumulativeLoginDays);
                SqlParameters[82] = new SqlParameter("@accumulativeAwardDays", (object)player.accumulativeAwardDays);
                SqlParameters[83] = new SqlParameter("@PveEpicPermission", (object)player.PveEpicPermission);
                SqlParameters[84] = new SqlParameter("@evolutionGrade", (object)player.evolutionGrade);
                SqlParameters[85] = new SqlParameter("@evolutionExp", (object)player.evolutionExp);
                SqlParameters[86] = new SqlParameter("@MagicAttack", (object)player.MagicAttack);
                SqlParameters[87] = new SqlParameter("@MagicDefence", (object)player.MagicDefence);
                SqlParameters[88] = new SqlParameter("@honorId", (object)player.honorId);
                SqlParameters[89] = new SqlParameter("@horseRaceCanRaceTime", (object)player.horseRaceCanRaceTime);
                this.db.RunProcedure("SP_Users_Update", SqlParameters);
                if (flag = (int)SqlParameters[21].Value == 0)
                {
                    player.AntiAddiction = (int)SqlParameters[20].Value;
                    player.CheckCount = (int)SqlParameters[24].Value;
                }
                player.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdatePlayerMarry(PlayerInfo player)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Users_Marry", new SqlParameter[7]
                {
          new SqlParameter("@UserID", (object) player.ID),
          new SqlParameter("@IsMarried", (object) player.IsMarried),
          new SqlParameter("@SpouseID", (object) player.SpouseID),
          new SqlParameter("@SpouseName", (object) player.SpouseName),
          new SqlParameter("@IsCreatedMarryRoom", (object) player.IsCreatedMarryRoom),
          new SqlParameter("@SelfMarryRoomID", (object) player.SelfMarryRoomID),
          new SqlParameter("@IsGotRing", (object) player.IsGotRing)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(UpdatePlayerMarry), ex);
            }
            return flag;
        }

        public bool UpdatePlayerLastAward(int id, int type)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Users_LastAward", new SqlParameter[2]
                {
          new SqlParameter("@UserID", (object) id),
          new SqlParameter("@Type", (object) type)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"UpdatePlayerAward", ex);
            }
            return flag;
        }

        public PlayerInfo InitPlayerInfo(SqlDataReader reader)
        {
            PlayerInfo playerInfo1 = new PlayerInfo();
            playerInfo1.Password = (string)reader["Password"];
            playerInfo1.IsConsortia = (bool)reader["IsConsortia"];
            playerInfo1.Agility = (int)reader["Agility"];
            playerInfo1.Attack = (int)reader["Attack"];
            playerInfo1.hp = (int)reader["hp"];
            playerInfo1.Colors = reader["Colors"] == null ? "" : reader["Colors"].ToString();
            playerInfo1.ConsortiaID = (int)reader["ConsortiaID"];
            playerInfo1.Defence = (int)reader["Defence"];
            playerInfo1.Gold = (int)reader["Gold"];
            playerInfo1.GP = (int)reader["GP"];
            playerInfo1.Grade = (int)reader["Grade"];
            playerInfo1.ID = (int)reader["UserID"];
            playerInfo1.Luck = (int)reader["Luck"];
            playerInfo1.Money = (int)reader["Money"];
            playerInfo1.NickName = (string)reader["NickName"] == null ? "" : (string)reader["NickName"];
            playerInfo1.Sex = (bool)reader["Sex"];
            playerInfo1.State = (int)reader["State"];
            playerInfo1.Style = reader["Style"] == null ? "" : reader["Style"].ToString();
            playerInfo1.Hide = (int)reader["Hide"];
            playerInfo1.Repute = (int)reader["Repute"];
            playerInfo1.UserName = reader["UserName"] == null ? "" : reader["UserName"].ToString();
            playerInfo1.ConsortiaName = reader["ConsortiaName"] == null ? "" : reader["ConsortiaName"].ToString();
            playerInfo1.Offer = (int)reader["Offer"];
            playerInfo1.Win = (int)reader["Win"];
            playerInfo1.Total = (int)reader["Total"];
            playerInfo1.Escape = (int)reader["Escape"];
            playerInfo1.Skin = reader["Skin"] == null ? "" : reader["Skin"].ToString();
            playerInfo1.IsBanChat = (bool)reader["IsBanChat"];
            playerInfo1.ReputeOffer = (int)reader["ReputeOffer"];
            playerInfo1.ConsortiaRepute = (int)reader["ConsortiaRepute"];
            playerInfo1.ConsortiaLevel = (int)reader["ConsortiaLevel"];
            playerInfo1.StoreLevel = (int)reader["StoreLevel"];
            playerInfo1.ShopLevel = (int)reader["ShopLevel"];
            playerInfo1.SmithLevel = (int)reader["SmithLevel"];
            playerInfo1.ConsortiaHonor = (int)reader["ConsortiaHonor"];
            playerInfo1.RichesOffer = (int)reader["RichesOffer"];
            playerInfo1.RichesRob = (int)reader["RichesRob"];
            playerInfo1.AntiAddiction = (int)reader["AntiAddiction"];
            playerInfo1.DutyLevel = (int)reader["DutyLevel"];
            playerInfo1.DutyName = reader["DutyName"] == null ? "" : reader["DutyName"].ToString();
            playerInfo1.Right = (int)reader["Right"];
            playerInfo1.ChairmanName = reader["ChairmanName"] == null ? "" : reader["ChairmanName"].ToString();
            playerInfo1.AddDayGP = (int)reader["AddDayGP"];
            playerInfo1.AddDayOffer = (int)reader["AddDayOffer"];
            playerInfo1.AddWeekGP = (int)reader["AddWeekGP"];
            playerInfo1.AddWeekOffer = (int)reader["AddWeekOffer"];
            playerInfo1.ConsortiaRiches = (int)reader["ConsortiaRiches"];
            playerInfo1.CheckCount = (int)reader["CheckCount"];
            playerInfo1.IsMarried = (bool)reader["IsMarried"];
            playerInfo1.SpouseID = (int)reader["SpouseID"];
            playerInfo1.SpouseName = reader["SpouseName"] == null ? "" : reader["SpouseName"].ToString();
            playerInfo1.MarryInfoID = (int)reader["MarryInfoID"];
            playerInfo1.IsCreatedMarryRoom = (bool)reader["IsCreatedMarryRoom"];
            playerInfo1.DayLoginCount = (int)reader["DayLoginCount"];
            playerInfo1.PasswordTwo = reader["PasswordTwo"] == null ? "" : reader["PasswordTwo"].ToString();
            playerInfo1.SelfMarryRoomID = (int)reader["SelfMarryRoomID"];
            playerInfo1.IsGotRing = (bool)reader["IsGotRing"];
            playerInfo1.Rename = (bool)reader["Rename"];
            playerInfo1.ConsortiaRename = (bool)reader["ConsortiaRename"];
            playerInfo1.IsDirty = false;
            playerInfo1.IsFirst = (int)reader["IsFirst"];
            playerInfo1.Nimbus = (int)reader["Nimbus"];
            playerInfo1.LastAward = (DateTime)reader["LastAward"];
            playerInfo1.DDTMoney = (int)reader["GiftToken"];
            playerInfo1.QuestSite = reader["QuestSite"] == null ? new byte[200] : (byte[])reader["QuestSite"];
            playerInfo1.PvePermission = reader["PvePermission"] == null ? "" : reader["PvePermission"].ToString();
            playerInfo1.FightPower = (int)reader["FightPower"];
            playerInfo1.PasswordQuest1 = reader["PasswordQuestion1"] == null ? "" : reader["PasswordQuestion1"].ToString();
            playerInfo1.PasswordQuest2 = reader["PasswordQuestion2"] == null ? "" : reader["PasswordQuestion2"].ToString();
            PlayerInfo playerInfo2 = playerInfo1;
            DateTime dateTime = (DateTime)reader["LastFindDate"];
            playerInfo2.FailedPasswordAttemptCount = (int)reader["FailedPasswordAttemptCount"];
            playerInfo1.AnswerSite = (int)reader["AnswerSite"];
            playerInfo1.medal = (int)reader["Medal"];
            playerInfo1.ChatCount = (int)reader["ChatCount"];
            playerInfo1.SpaPubGoldRoomLimit = (int)reader["SpaPubGoldRoomLimit"];
            playerInfo1.LastSpaDate = (DateTime)reader["LastSpaDate"];
            playerInfo1.FightLabPermission = (string)reader["FightLabPermission"];
            playerInfo1.SpaPubMoneyRoomLimit = (int)reader["SpaPubMoneyRoomLimit"];
            playerInfo1.IsInSpaPubGoldToday = (bool)reader["IsInSpaPubGoldToday"];
            playerInfo1.IsInSpaPubMoneyToday = (bool)reader["IsInSpaPubMoneyToday"];
            playerInfo1.AchievementPoint = (int)reader["AchievementPoint"];
            playerInfo1.LastWeekly = (DateTime)reader["LastWeekly"];
            playerInfo1.LastWeeklyVersion = (int)reader["LastWeeklyVersion"];
            playerInfo1.GiftGp = (int)reader["GiftGp"];
            playerInfo1.GiftLevel = (int)reader["GiftLevel"];
            playerInfo1.IsOpenGift = (bool)reader["IsOpenGift"];
            playerInfo1.badgeID = (int)reader["badgeID"];
            playerInfo1.typeVIP = Convert.ToByte(reader["typeVIP"]);
            playerInfo1.VIPLevel = (int)reader["VIPLevel"];
            playerInfo1.VIPExp = (int)reader["VIPExp"];
            playerInfo1.VIPExpireDay = (DateTime)reader["VIPExpireDay"];
            playerInfo1.LastVIPPackTime = (DateTime)reader["LastVIPPackTime"];
            playerInfo1.CanTakeVipReward = (bool)reader["CanTakeVipReward"];
            playerInfo1.WeaklessGuildProgressStr = (string)reader["WeaklessGuildProgressStr"];
            playerInfo1.IsOldPlayer = (bool)reader["IsOldPlayer"];
            playerInfo1.LastDate = (DateTime)reader["LastDate"];
            playerInfo1.DateTime_0 = (DateTime)reader["VIPLastDate"];
            playerInfo1.Score = (int)reader["Score"];
            playerInfo1.OptionOnOff = (int)reader["OptionOnOff"];
            playerInfo1.isOldPlayerHasValidEquitAtLogin = (bool)reader["isOldPlayerHasValidEquitAtLogin"];
            playerInfo1.badLuckNumber = (int)reader["badLuckNumber"];
            playerInfo1.luckyNum = (int)reader["luckyNum"];
            playerInfo1.lastLuckyNumDate = (DateTime)reader["lastLuckyNumDate"];
            playerInfo1.lastLuckNum = (int)reader["lastLuckNum"];
            playerInfo1.CardSoul = (int)reader["CardSoul"];
            playerInfo1.uesedFinishTime = (int)reader["uesedFinishTime"];
            playerInfo1.totemId = (int)reader["totemId"];
            playerInfo1.damageScores = (int)reader["damageScores"];
            playerInfo1.petScore = (int)reader["petScore"];
            playerInfo1.IsShowConsortia = (bool)reader["IsShowConsortia"];
            playerInfo1.LastRefreshPet = (DateTime)reader["LastRefreshPet"];
            playerInfo1.GetSoulCount = (int)reader["GetSoulCount"];
            playerInfo1.isFirstDivorce = (int)reader["isFirstDivorce"];
            playerInfo1.myScore = (int)reader["myScore"];
            playerInfo1.LastGetEgg = (DateTime)reader["LastGetEgg"];
            playerInfo1.TimeBox = (DateTime)reader["TimeBox"];
            playerInfo1.IsFistGetPet = (bool)reader["IsFistGetPet"];
            playerInfo1.myHonor = (int)reader["myHonor"];
            playerInfo1.hardCurrency = (int)reader["hardCurrency"];
            playerInfo1.MaxBuyHonor = (int)reader["MaxBuyHonor"];
            playerInfo1.LeagueMoney = (int)reader["LeagueMoney"];
            playerInfo1.Honor = (string)reader["Honor"];
            playerInfo1.necklaceExp = (int)reader["necklaceExp"];
            playerInfo1.necklaceExpAdd = (int)reader["necklaceExpAdd"];
            playerInfo1.accumulativeLoginDays = (int)reader["accumulativeLoginDays"];
            playerInfo1.accumulativeAwardDays = (int)reader["accumulativeAwardDays"];
            playerInfo1.MountsType = (int)reader["MountsType"];
            playerInfo1.PveEpicPermission = (string)reader["PveEpicPermission"];
            playerInfo1.evolutionGrade = (int)reader["evolutionGrade"];
            playerInfo1.evolutionExp = (int)reader["evolutionExp"];
            playerInfo1.MagicAttack = (int)reader["MagicAttack"];
            playerInfo1.MagicDefence = (int)reader["MagicDefence"];
            playerInfo1.honorId = (int)reader["honorId"];
            playerInfo1.MountExp = (int)reader["curExp"];
            playerInfo1.MountLv = (int)reader["curLevel"];
            playerInfo1.PetsID = (int)reader["PetsID"];
            playerInfo1.horseRaceCanRaceTime = (int)reader["horseRaceCanRaceTime"];
            return playerInfo1;
        }

        public SqlDataProvider.Data.ItemInfo InitItem(SqlDataReader reader)
        {
            SqlDataProvider.Data.ItemInfo itemInfo = new SqlDataProvider.Data.ItemInfo(ItemMgr.FindItemTemplate((int)reader["TemplateID"]));
            itemInfo.AgilityCompose = (int)reader["AgilityCompose"];
            itemInfo.AttackCompose = (int)reader["AttackCompose"];
            itemInfo.Color = reader["Color"].ToString();
            itemInfo.Count = (int)reader["Count"];
            itemInfo.DefendCompose = (int)reader["DefendCompose"];
            itemInfo.ItemID = (int)reader["ItemID"];
            itemInfo.LuckCompose = (int)reader["LuckCompose"];
            itemInfo.Place = (int)reader["Place"];
            itemInfo.StrengthenLevel = (int)reader["StrengthenLevel"];
            itemInfo.TemplateID = (int)reader["TemplateID"];
            itemInfo.UserID = (int)reader["UserID"];
            itemInfo.ValidDate = (int)reader["ValidDate"];
            itemInfo.IsDirty = false;
            itemInfo.IsExist = (bool)reader["IsExist"];
            itemInfo.IsBinds = (bool)reader["IsBinds"];
            itemInfo.IsUsed = (bool)reader["IsUsed"];
            itemInfo.BeginDate = (DateTime)reader["BeginDate"];
            itemInfo.IsJudge = (bool)reader["IsJudge"];
            itemInfo.BagType = (int)reader["BagType"];
            itemInfo.Skin = reader["Skin"].ToString();
            itemInfo.RemoveDate = (DateTime)reader["RemoveDate"];
            itemInfo.RemoveType = (int)reader["RemoveType"];
            itemInfo.Hole1 = (int)reader["Hole1"];
            itemInfo.Hole2 = (int)reader["Hole2"];
            itemInfo.Hole3 = (int)reader["Hole3"];
            itemInfo.Hole4 = (int)reader["Hole4"];
            itemInfo.Hole5 = (int)reader["Hole5"];
            itemInfo.Hole6 = (int)reader["Hole6"];
            itemInfo.StrengthenTimes = (int)reader["StrengthenTimes"];
            itemInfo.StrengthenExp = (int)reader["StrengthenExp"];
            itemInfo.Int32_0 = (int)reader["Hole5Level"];
            itemInfo.Hole5Exp = (int)reader["Hole5Exp"];
            itemInfo.Int32_1 = (int)reader["Hole6Level"];
            itemInfo.Hole6Exp = (int)reader["Hole6Exp"];
            itemInfo.goldBeginTime = (DateTime)reader["goldBeginTime"];
            itemInfo.goldValidDate = (int)reader["goldValidDate"];
            itemInfo.beadExp = (int)reader["beadExp"];
            itemInfo.beadLevel = (int)reader["beadLevel"];
            itemInfo.beadIsLock = (bool)reader["beadIsLock"];
            itemInfo.isShowBind = (bool)reader["isShowBind"];
            itemInfo.latentEnergyCurStr = (string)reader["latentEnergyCurStr"];
            itemInfo.latentEnergyNewStr = (string)reader["latentEnergyNewStr"];
            itemInfo.latentEnergyEndTime = (DateTime)reader["latentEnergyEndTime"];
            itemInfo.Damage = (int)reader["Damage"];
            itemInfo.Guard = (int)reader["Guard"];
            itemInfo.Blood = (int)reader["Blood"];
            itemInfo.Bless = (int)reader["Bless"];
            itemInfo.AdvanceDate = (DateTime)reader["AdvanceDate"];
            itemInfo.AvatarActivity = (bool)reader["AvatarActivity"];
            itemInfo.goodsLock = (bool)reader["goodsLock"];
            itemInfo.MagicAttack = (int)reader["MagicAttack"];
            itemInfo.MagicDefence = (int)reader["MagicDefence"];
            itemInfo.GoldEquip = ItemMgr.FindGoldItemTemplate(itemInfo.TemplateID, itemInfo.IsGold);
            itemInfo.MagicExp = (int)reader["MagicExp"];
            itemInfo.MagicLevel = (int)reader["MagicLevel"];
            return itemInfo;
        }

        public UsersPetinfo InitPet(SqlDataReader reader)
        {
            return new UsersPetinfo()
            {
                ID = (int)reader["ID"],
                TemplateID = (int)reader["TemplateID"],
                Name = reader["Name"].ToString(),
                UserID = (int)reader["UserID"],
                Attack = (int)reader["Attack"],
                AttackGrow = (int)reader["AttackGrow"],
                Agility = (int)reader["Agility"],
                AgilityGrow = (int)reader["AgilityGrow"],
                Defence = (int)reader["Defence"],
                DefenceGrow = (int)reader["DefenceGrow"],
                Luck = (int)reader["Luck"],
                LuckGrow = (int)reader["LuckGrow"],
                Blood = (int)reader["Blood"],
                BloodGrow = (int)reader["BloodGrow"],
                Damage = (int)reader["Damage"],
                DamageGrow = (int)reader["DamageGrow"],
                Guard = (int)reader["Guard"],
                GuardGrow = (int)reader["GuardGrow"],
                Level = (int)reader["Level"],
                GP = (int)reader["GP"],
                MaxGP = (int)reader["MaxGP"],
                Hunger = (int)reader["Hunger"],
                MP = (int)reader["MP"],
                Place = (int)reader["Place"],
                IsEquip = (bool)reader["IsEquip"],
                IsExit = (bool)reader["IsExit"],
                Skill = reader["Skill"].ToString(),
                SkillEquip = reader["SkillEquip"].ToString(),
                currentStarExp = (int)reader["currentStarExp"]
            };
        }

        public UsersCardInfo InitCard(SqlDataReader reader)
        {
            return new UsersCardInfo()
            {
                UserID = (int)reader["UserID"],
                TemplateID = (int)reader["TemplateID"],
                CardID = (int)reader["CardID"],
                CardType = (int)reader["CardType"],
                Attack = (int)reader["Attack"],
                Agility = (int)reader["Agility"],
                Defence = (int)reader["Defence"],
                Luck = (int)reader["Luck"],
                Damage = (int)reader["Damage"],
                Guard = (int)reader["Guard"],
                Level = (int)reader["Level"],
                Place = (int)reader["Place"],
                isFirstGet = (bool)reader["isFirstGet"],
                Type = (int)reader["Type"],
                CardGP = (int)reader["CardGP"]
            };
        }

        public TexpInfo InitTexpInfo(SqlDataReader reader)
        {
            return new TexpInfo()
            {
                UserID = (int)reader["UserID"],
                attTexpExp = (int)reader["attTexpExp"],
                defTexpExp = (int)reader["defTexpExp"],
                hpTexpExp = (int)reader["hpTexpExp"],
                lukTexpExp = (int)reader["lukTexpExp"],
                spdTexpExp = (int)reader["spdTexpExp"],
                texpCount = (int)reader["texpCount"],
                texpTaskCount = (int)reader["texpTaskCount"],
                texpTaskDate = (DateTime)reader["texpTaskDate"]
            };
        }

        public UserGemStone InitGemStones(SqlDataReader reader)
        {
            return new UserGemStone()
            {
                ID = (int)reader["ID"],
                UserID = (int)reader["UserID"],
                FigSpiritId = (int)reader["FigSpiritId"],
                FigSpiritIdValue = (string)reader["FigSpiritIdValue"],
                EquipPlace = (int)reader["EquipPlace"]
            };
        }

        public PlayerInfo GetUserSingleByUserID(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Users_SingleByUserID", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitPlayerInfo(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (PlayerInfo)null;
        }

        public PlayerLimitInfo GetUserLimitByUserName(string userName)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserName", SqlDbType.NVarChar, 200)
                };
                SqlParameters[0].Value = (object)userName;
                this.db.GetReader(ref ResultDataReader, "SP_Users_LimitByUserName", SqlParameters);
                if (ResultDataReader.Read())
                    return new PlayerLimitInfo()
                    {
                        ID = (int)ResultDataReader["UserID"],
                        NickName = (string)ResultDataReader["NickName"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (PlayerLimitInfo)null;
        }

        public PlayerInfo GetUserSingleByUserName(string userName)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserName", SqlDbType.NVarChar, 200)
                };
                SqlParameters[0].Value = (object)userName;
                this.db.GetReader(ref ResultDataReader, "SP_Users_SingleByUserName", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitPlayerInfo(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (PlayerInfo)null;
        }

        public PlayerInfo GetUserSingleByNickName(string nickName)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@NickName", SqlDbType.NVarChar, 200)
                };
                SqlParameters[0].Value = (object)nickName;
                this.db.GetReader(ref ResultDataReader, "SP_Users_SingleByNickName", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitPlayerInfo(ResultDataReader);
            }
            catch
            {
                throw new Exception();
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (PlayerInfo)null;
        }

        public UserRankDateInfo GetUserRankDateByID(int userID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)userID;
                this.db.GetReader(ref ResultDataReader, "SP_Sys_Users_Rank_Date", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitUserRankDateInfo(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitUserRankDateInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (UserRankDateInfo)null;
        }

        public UserRankDateInfo[] GetAllUserRankDate()
        {
            List<UserRankDateInfo> userRankDateInfoList = new List<UserRankDateInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[0];
                this.db.GetReader(ref ResultDataReader, "SP_Sys_Users_Rank_Date_All", SqlParameters);
                while (ResultDataReader.Read())
                    userRankDateInfoList.Add(this.InitUserRankDateInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitUserRankDateInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return userRankDateInfoList.ToArray();
        }

        public UserRankDateInfo InitUserRankDateInfo(SqlDataReader dr)
        {
            return new UserRankDateInfo()
            {
                UserID = (int)dr["UserID"],
                ConsortiaID = (int)dr["ConsortiaID"],
                FightPower = (int)dr["FightPower"],
                PrevFightPower = (int)dr["PrevFightPower"],
                GP = (int)dr["GP"],
                PrevGP = (int)dr["PrevGP"],
                AchievementPoint = (int)dr["AchievementPoint"],
                PrevAchievementPoint = (int)dr["PrevAchievementPoint"],
                GiftGp = (int)dr["GiftGp"],
                PrevGiftGp = (int)dr["PrevGiftGp"],
                LeagueAddWeek = (int)dr["LeagueAddWeek"],
                PrevLeagueAddWeek = (int)dr["PrevLeagueAddWeek"],
                MountExp = (int)dr["MountExp"],
                PrevMountExp = (int)dr["PrevMountExp"],
                ConsortiaFightPower = (int)dr["ConsortiaFightPower"],
                ConsortiaPrevFightPower = (int)dr["ConsortiaPrevFightPower"],
                ConsortiaLevel = (int)dr["ConsortiaLevel"],
                ConsortiaPrevLevel = (int)dr["ConsortiaPrevLevel"],
                ConsortiaRiches = (int)dr["ConsortiaRiches"],
                ConsortiaPrevRiches = (int)dr["ConsortiaPrevRiches"],
                ConsortiaGiftGp = (int)dr["ConsortiaGiftGp"],
                ConsortiaPrevGiftGp = (int)dr["ConsortiaPrevGiftGp"]
            };
        }

        public bool UpdateRank()
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[0];
                flag = this.db.RunProcedure("SP_Sys_Update_Consortia_DayList", SqlParameters);
                flag = this.db.RunProcedure("SP_Sys_Update_Consortia_FightPower", SqlParameters);
                flag = this.db.RunProcedure("SP_Sys_Update_Consortia_Honor", SqlParameters);
                flag = this.db.RunProcedure("SP_Sys_Update_Consortia_List", SqlParameters);
                flag = this.db.RunProcedure("SP_Sys_Update_Consortia_WeekList", SqlParameters);
                flag = this.db.RunProcedure("SP_Sys_Update_OfferList", SqlParameters);
                flag = this.db.RunProcedure("SP_Sys_Update_Users_DayList", SqlParameters);
                flag = this.db.RunProcedure("SP_Sys_Update_Users_List", SqlParameters);
                flag = this.db.RunProcedure("SP_Sys_Update_Users_WeekList", SqlParameters);
                flag = this.db.RunProcedure("SP_Sys_Update_Users_Rank_Date", SqlParameters);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init UpdatePersonalRank", ex);
            }
            return flag;
        }

        public PlayerInfo[] GetPlayerPage(
          int page,
          int size,
          ref int total,
          int order,
          int userID,
          ref bool resultValue)
        {
            List<PlayerInfo> playerInfoList = new List<PlayerInfo>();
            try
            {
                string queryWhere = " IsExist=1 and IsFirst<> 0 ";
                if (userID != -1)
                    queryWhere = queryWhere + " and UserID =" + (object)userID + " ";
                string str = "GP desc";
                switch (order)
                {
                    case 1:
                        str = "Offer desc";
                        break;
                    case 2:
                        str = "AddDayGP desc";
                        break;
                    case 3:
                        str = "AddWeekGP desc";
                        break;
                    case 4:
                        str = "AddDayOffer desc";
                        break;
                    case 5:
                        str = "AddWeekOffer desc";
                        break;
                    case 6:
                        str = "FightPower desc";
                        break;
                    case 7:
                        str = "AchievementPoint desc";
                        break;
                    case 8:
                        str = "AddDayAchievementPoint desc";
                        break;
                    case 9:
                        str = "AddWeekAchievementPoint desc";
                        break;
                    case 10:
                        str = "GiftGp desc";
                        break;
                    case 11:
                        str = "AddDayGiftGp desc";
                        break;
                    case 12:
                        str = "AddWeekGiftGp desc";
                        break;
                    case 13:
                        str = "totalPrestige desc";
                        break;
                    case 14:
                        str = "curExp desc";
                        break;
                }
                string fdOreder = str + ",UserID";
                foreach (DataRow row in (InternalDataCollectionBase)this.GetPage("V_Sys_Users_Detail", queryWhere, page, size, "*", fdOreder, "UserID", ref total).Rows)
                {
                    PlayerInfo playerInfo = new PlayerInfo()
                    {
                        Agility = (int)row["Agility"],
                        Attack = (int)row["Attack"],
                        Colors = row["Colors"] == null ? "" : row["Colors"].ToString(),
                        ConsortiaID = (int)row["ConsortiaID"],
                        Defence = (int)row["Defence"],
                        Gold = (int)row["Gold"],
                        GP = (int)row["GP"],
                        Grade = (int)row["Grade"],
                        ID = (int)row["UserID"],
                        Luck = (int)row["Luck"],
                        Money = (int)row["Money"],
                        NickName = row["NickName"] == null ? "" : row["NickName"].ToString(),
                        Sex = (bool)row["Sex"],
                        State = (int)row["State"],
                        Style = row["Style"] == null ? "" : row["Style"].ToString(),
                        Hide = (int)row["Hide"],
                        Repute = (int)row["Repute"],
                        UserName = row["UserName"] == null ? "" : row["UserName"].ToString(),
                        ConsortiaName = row["ConsortiaName"] == null ? "" : row["ConsortiaName"].ToString(),
                        Offer = (int)row["Offer"],
                        Skin = row["Skin"] == null ? "" : row["Skin"].ToString(),
                        IsBanChat = (bool)row["IsBanChat"],
                        ReputeOffer = (int)row["ReputeOffer"],
                        ConsortiaRepute = (int)row["ConsortiaRepute"],
                        ConsortiaLevel = (int)row["ConsortiaLevel"],
                        StoreLevel = (int)row["StoreLevel"],
                        ShopLevel = (int)row["ShopLevel"],
                        SmithLevel = (int)row["SmithLevel"],
                        ConsortiaHonor = (int)row["ConsortiaHonor"],
                        RichesOffer = (int)row["RichesOffer"],
                        RichesRob = (int)row["RichesRob"],
                        DutyLevel = (int)row["DutyLevel"],
                        DutyName = row["DutyName"] == null ? "" : row["DutyName"].ToString(),
                        Right = (int)row["Right"],
                        ChairmanName = row["ChairmanName"] == null ? "" : row["ChairmanName"].ToString(),
                        Win = (int)row["Win"],
                        Total = (int)row["Total"],
                        Escape = (int)row["Escape"]
                    };
                    playerInfo.AddDayGP = (int)row["AddDayGP"] == 0 ? playerInfo.GP : (int)row["AddDayGP"];
                    playerInfo.AddDayOffer = (int)row["AddDayOffer"] == 0 ? playerInfo.Offer : (int)row["AddDayOffer"];
                    playerInfo.AddWeekGP = (int)row["AddWeekGP"] == 0 ? playerInfo.GP : (int)row["AddWeekGP"];
                    playerInfo.AddWeekOffer = (int)row["AddWeekOffer"] == 0 ? playerInfo.Offer : (int)row["AddWeekOffer"];
                    playerInfo.ConsortiaRiches = (int)row["ConsortiaRiches"];
                    playerInfo.CheckCount = (int)row["CheckCount"];
                    playerInfo.Nimbus = (int)row["Nimbus"];
                    playerInfo.DDTMoney = (int)row["GiftToken"];
                    playerInfo.QuestSite = row["QuestSite"] == null ? new byte[200] : (byte[])row["QuestSite"];
                    playerInfo.PvePermission = row["PvePermission"] == null ? "" : row["PvePermission"].ToString();
                    playerInfo.FightPower = (int)row["FightPower"];
                    playerInfo.Honor = row["Honor"] == null ? "" : row["Honor"].ToString();
                    playerInfo.GiftGp = (int)row["GiftGp"];
                    playerInfo.GiftLevel = (int)row["GiftLevel"];
                    playerInfo.AddWeekLeagueScore = (int)row["weeklyScore"];
                    playerInfo.TotalPrestige = (int)row["totalPrestige"];
                    playerInfo.MountExp = (int)row["curExp"];
                    playerInfo.MountLv = (int)row["curLevel"];
                    playerInfo.IsOldPlayer = (bool)row["IsOldPlayer"];
                    playerInfoList.Add(playerInfo);
                }
                resultValue = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return playerInfoList.ToArray();
        }

        public SqlDataProvider.Data.ItemInfo[] GetUserItem(int UserID)
        {
            List<SqlDataProvider.Data.ItemInfo> itemInfoList = new List<SqlDataProvider.Data.ItemInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Users_Items_All", SqlParameters);
                while (ResultDataReader.Read())
                    itemInfoList.Add(this.InitItem(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return itemInfoList.ToArray();
        }

        public SqlDataProvider.Data.ItemInfo[] GetUserBagByType(int UserID, int bagType)
        {
            List<SqlDataProvider.Data.ItemInfo> itemInfoList = new List<SqlDataProvider.Data.ItemInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4),
          null
                };
                SqlParameters[0].Value = (object)UserID;
                SqlParameters[1] = new SqlParameter("@BagType", (object)bagType);
                this.db.GetReader(ref ResultDataReader, "SP_Users_BagByType", SqlParameters);
                while (ResultDataReader.Read())
                    itemInfoList.Add(this.InitItem(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return itemInfoList.ToArray();
        }

        public List<SqlDataProvider.Data.ItemInfo> GetUserEuqip(int UserID)
        {
            List<SqlDataProvider.Data.ItemInfo> userEuqip = new List<SqlDataProvider.Data.ItemInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Users_Items_Equip", SqlParameters);
                while (ResultDataReader.Read())
                    userEuqip.Add(this.InitItem(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return userEuqip;
        }

        public List<SqlDataProvider.Data.ItemInfo> GetUserBeadEuqip(int UserID)
        {
            List<SqlDataProvider.Data.ItemInfo> userBeadEuqip = new List<SqlDataProvider.Data.ItemInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Users_Bead_Equip", SqlParameters);
                while (ResultDataReader.Read())
                    userBeadEuqip.Add(this.InitItem(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return userBeadEuqip;
        }

        public List<SqlDataProvider.Data.ItemInfo> GetUserMagicstoneEuqip(int UserID)
        {
            List<SqlDataProvider.Data.ItemInfo> userMagicstoneEuqip = new List<SqlDataProvider.Data.ItemInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Magicstone_Equip", SqlParameters);
                while (ResultDataReader.Read())
                    userMagicstoneEuqip.Add(this.InitItem(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return userMagicstoneEuqip;
        }

        public List<SqlDataProvider.Data.ItemInfo> GetUserEuqipByNick(string Nick)
        {
            List<SqlDataProvider.Data.ItemInfo> userEuqipByNick = new List<SqlDataProvider.Data.ItemInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@NickName", SqlDbType.NVarChar, 200)
                };
                SqlParameters[0].Value = (object)Nick;
                this.db.GetReader(ref ResultDataReader, "SP_Users_Items_Equip_By_Nick", SqlParameters);
                while (ResultDataReader.Read())
                    userEuqipByNick.Add(this.InitItem(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return userEuqipByNick;
        }

        public SqlDataProvider.Data.ItemInfo GetUserItemSingle(int itemID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)itemID;
                this.db.GetReader(ref ResultDataReader, "SP_Users_Items_Single", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitItem(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (SqlDataProvider.Data.ItemInfo)null;
        }

        public bool AddGoods(SqlDataProvider.Data.ItemInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[53];
                SqlParameters[0] = new SqlParameter("@ItemID", (object)item.ItemID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)item.UserID);
                SqlParameters[2] = new SqlParameter("@TemplateID", (object)item.Template.TemplateID);
                SqlParameters[3] = new SqlParameter("@Place", (object)item.Place);
                SqlParameters[4] = new SqlParameter("@AgilityCompose", (object)item.AgilityCompose);
                SqlParameters[5] = new SqlParameter("@AttackCompose", (object)item.AttackCompose);
                SqlParameters[6] = new SqlParameter("@BeginDate", (object)item.BeginDate);
                SqlParameters[7] = new SqlParameter("@Color", item.Color == null ? (object)"" : (object)item.Color);
                SqlParameters[8] = new SqlParameter("@Count", (object)item.Count);
                SqlParameters[9] = new SqlParameter("@DefendCompose", (object)item.DefendCompose);
                SqlParameters[10] = new SqlParameter("@IsBinds", (object)item.IsBinds);
                SqlParameters[11] = new SqlParameter("@IsExist", (object)item.IsExist);
                SqlParameters[12] = new SqlParameter("@IsJudge", (object)item.IsJudge);
                SqlParameters[13] = new SqlParameter("@LuckCompose", (object)item.LuckCompose);
                SqlParameters[14] = new SqlParameter("@StrengthenLevel", (object)item.StrengthenLevel);
                SqlParameters[15] = new SqlParameter("@ValidDate", (object)item.ValidDate);
                SqlParameters[16] = new SqlParameter("@BagType", (object)item.BagType);
                SqlParameters[17] = new SqlParameter("@Skin", item.Skin == null ? (object)"" : (object)item.Skin);
                SqlParameters[18] = new SqlParameter("@IsUsed", (object)item.IsUsed);
                SqlParameters[19] = new SqlParameter("@RemoveType", (object)item.RemoveType);
                SqlParameters[20] = new SqlParameter("@Hole1", (object)item.Hole1);
                SqlParameters[21] = new SqlParameter("@Hole2", (object)item.Hole2);
                SqlParameters[22] = new SqlParameter("@Hole3", (object)item.Hole3);
                SqlParameters[23] = new SqlParameter("@Hole4", (object)item.Hole4);
                SqlParameters[24] = new SqlParameter("@Hole5", (object)item.Hole5);
                SqlParameters[25] = new SqlParameter("@Hole6", (object)item.Hole6);
                SqlParameters[26] = new SqlParameter("@StrengthenTimes", (object)item.StrengthenTimes);
                SqlParameters[27] = new SqlParameter("@Hole5Level", (object)item.Int32_0);
                SqlParameters[28] = new SqlParameter("@Hole5Exp", (object)item.Hole5Exp);
                SqlParameters[29] = new SqlParameter("@Hole6Level", (object)item.Int32_1);
                SqlParameters[30] = new SqlParameter("@Hole6Exp", (object)item.Hole6Exp);
                SqlParameters[31] = new SqlParameter("@IsGold", (object)item.IsGold);
                SqlParameters[32] = new SqlParameter("@goldValidDate", (object)item.goldValidDate);
                SqlParameters[33] = new SqlParameter("@StrengthenExp", (object)item.StrengthenExp);
                SqlParameters[34] = new SqlParameter("@beadExp", (object)item.beadExp);
                SqlParameters[35] = new SqlParameter("@beadLevel", (object)item.beadLevel);
                SqlParameters[36] = new SqlParameter("@beadIsLock", (object)item.beadIsLock);
                SqlParameters[37] = new SqlParameter("@isShowBind", (object)item.isShowBind);
                SqlParameters[38] = new SqlParameter("@Damage", (object)item.Damage);
                SqlParameters[39] = new SqlParameter("@Guard", (object)item.Guard);
                SqlParameters[40] = new SqlParameter("@Blood", (object)item.Blood);
                SqlParameters[41] = new SqlParameter("@Bless", (object)item.Bless);
                SqlParameters[42] = new SqlParameter("@goldBeginTime", (object)item.goldBeginTime);
                SqlParameters[43] = new SqlParameter("@latentEnergyEndTime", (object)item.latentEnergyEndTime);
                SqlParameters[44] = new SqlParameter("@latentEnergyCurStr", (object)item.latentEnergyCurStr);
                SqlParameters[45] = new SqlParameter("@latentEnergyNewStr", (object)item.latentEnergyNewStr);
                SqlParameters[46] = new SqlParameter("@AdvanceDate", (object)item.AdvanceDate);
                SqlParameters[47] = new SqlParameter("@AvatarActivity", (object)item.AvatarActivity);
                SqlParameters[48] = new SqlParameter("@goodsLock", (object)item.goodsLock);
                SqlParameters[49] = new SqlParameter("@MagicAttack", (object)item.MagicAttack);
                SqlParameters[50] = new SqlParameter("@MagicDefence", (object)item.MagicDefence);
                SqlParameters[51] = new SqlParameter("@MagicExp", (object)item.MagicExp);
                SqlParameters[52] = new SqlParameter("@MagicLevel", (object)item.MagicLevel);
                flag = this.db.RunProcedure("SP_Users_Items_Add", SqlParameters);
                item.ItemID = (int)SqlParameters[0].Value;
                item.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateGoods(SqlDataProvider.Data.ItemInfo item)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Users_Items_Update", new SqlParameter[54]
                {
          new SqlParameter("@ItemID", (object) item.ItemID),
          new SqlParameter("@UserID", (object) item.UserID),
          new SqlParameter("@TemplateID", (object) item.Template.TemplateID),
          new SqlParameter("@Place", (object) item.Place),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@BeginDate", (object) item.BeginDate),
          new SqlParameter("@Color", item.Color == null ? (object) "" : (object) item.Color),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@IsBinds", (object) item.IsBinds),
          new SqlParameter("@IsExist", (object) item.IsExist),
          new SqlParameter("@IsJudge", (object) item.IsJudge),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@ValidDate", (object) item.ValidDate),
          new SqlParameter("@BagType", (object) item.BagType),
          new SqlParameter("@Skin", (object) item.Skin),
          new SqlParameter("@IsUsed", (object) item.IsUsed),
          new SqlParameter("@RemoveDate", (object) item.RemoveDate),
          new SqlParameter("@RemoveType", (object) item.RemoveType),
          new SqlParameter("@Hole1", (object) item.Hole1),
          new SqlParameter("@Hole2", (object) item.Hole2),
          new SqlParameter("@Hole3", (object) item.Hole3),
          new SqlParameter("@Hole4", (object) item.Hole4),
          new SqlParameter("@Hole5", (object) item.Hole5),
          new SqlParameter("@Hole6", (object) item.Hole6),
          new SqlParameter("@StrengthenTimes", (object) item.StrengthenTimes),
          new SqlParameter("@Hole5Level", (object) item.Int32_0),
          new SqlParameter("@Hole5Exp", (object) item.Hole5Exp),
          new SqlParameter("@Hole6Level", (object) item.Int32_1),
          new SqlParameter("@Hole6Exp", (object) item.Hole6Exp),
          new SqlParameter("@IsGold", (object) item.IsGold),
          new SqlParameter("@goldBeginTime", (object) item.goldBeginTime.ToString()),
          new SqlParameter("@goldValidDate", (object) item.goldValidDate),
          new SqlParameter("@StrengthenExp", (object) item.StrengthenExp),
          new SqlParameter("@beadExp", (object) item.beadExp),
          new SqlParameter("@beadLevel", (object) item.beadLevel),
          new SqlParameter("@beadIsLock", (object) item.beadIsLock),
          new SqlParameter("@isShowBind", (object) item.isShowBind),
          new SqlParameter("@latentEnergyCurStr", (object) item.latentEnergyCurStr),
          new SqlParameter("@latentEnergyNewStr", (object) item.latentEnergyNewStr),
          new SqlParameter("@latentEnergyEndTime", (object) item.latentEnergyEndTime.ToString()),
          new SqlParameter("@Damage", (object) item.Damage),
          new SqlParameter("@Guard", (object) item.Guard),
          new SqlParameter("@Blood", (object) item.Blood),
          new SqlParameter("@Bless", (object) item.Bless),
          new SqlParameter("@AdvanceDate", (object) item.AdvanceDate),
          new SqlParameter("@AvatarActivity", (object) item.AvatarActivity),
          new SqlParameter("@goodsLock", (object) item.goodsLock),
          new SqlParameter("@MagicAttack", (object) item.MagicAttack),
          new SqlParameter("@MagicDefence", (object) item.MagicDefence),
          new SqlParameter("@MagicExp", (object) item.MagicExp),
          new SqlParameter("@MagicLevel", (object) item.MagicLevel)
                });
                item.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool DeleteGoods(int itemID)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Users_Items_Delete", new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) itemID)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public BestEquipInfo[] GetCelebByDayBestEquip()
        {
            List<BestEquipInfo> bestEquipInfoList = new List<BestEquipInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Users_BestEquip");
                while (ResultDataReader.Read())
                    bestEquipInfoList.Add(new BestEquipInfo()
                    {
                        Date = (DateTime)ResultDataReader["RemoveDate"],
                        GP = (int)ResultDataReader["GP"],
                        Grade = (int)ResultDataReader["Grade"],
                        ItemName = ResultDataReader["Name"] == null ? "" : ResultDataReader["Name"].ToString(),
                        NickName = ResultDataReader["NickName"] == null ? "" : ResultDataReader["NickName"].ToString(),
                        Sex = (bool)ResultDataReader["Sex"],
                        Strengthenlevel = (int)ResultDataReader["Strengthenlevel"],
                        UserName = ResultDataReader["UserName"] == null ? "" : ResultDataReader["UserName"].ToString()
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return bestEquipInfoList.ToArray();
        }

        public MailInfo InitMail(SqlDataReader reader)
        {
            return new MailInfo()
            {
                Annex1 = reader["Annex1"].ToString(),
                Annex2 = reader["Annex2"].ToString(),
                Content = reader["Content"].ToString(),
                Gold = (int)reader["Gold"],
                ID = (int)reader["ID"],
                IsExist = (bool)reader["IsExist"],
                Money = (int)reader["Money"],
                GiftToken = (int)reader["GiftToken"],
                Receiver = reader["Receiver"].ToString(),
                ReceiverID = (int)reader["ReceiverID"],
                Sender = reader["Sender"].ToString(),
                SenderID = (int)reader["SenderID"],
                Title = reader["Title"].ToString(),
                Type = (int)reader["Type"],
                ValidDate = (int)reader["ValidDate"],
                IsRead = (bool)reader["IsRead"],
                SendTime = (DateTime)reader["SendTime"],
                String_0 = reader["Annex1Name"] == null ? "" : reader["Annex1Name"].ToString(),
                String_1 = reader["Annex2Name"] == null ? "" : reader["Annex2Name"].ToString(),
                Annex3 = reader["Annex3"].ToString(),
                Annex4 = reader["Annex4"].ToString(),
                Annex5 = reader["Annex5"].ToString(),
                String_2 = reader["Annex3Name"] == null ? "" : reader["Annex3Name"].ToString(),
                String_3 = reader["Annex4Name"] == null ? "" : reader["Annex4Name"].ToString(),
                String_4 = reader["Annex5Name"] == null ? "" : reader["Annex5Name"].ToString(),
                AnnexRemark = reader["AnnexRemark"] == null ? "" : reader["AnnexRemark"].ToString()
            };
        }

        public MailInfo[] GetMailByUserID(int userID)
        {
            List<MailInfo> mailInfoList = new List<MailInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)userID;
                this.db.GetReader(ref ResultDataReader, "SP_Mail_ByUserID", SqlParameters);
                while (ResultDataReader.Read())
                    mailInfoList.Add(this.InitMail(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return mailInfoList.ToArray();
        }

        public MailInfo[] GetMailBySenderID(int userID)
        {
            List<MailInfo> mailInfoList = new List<MailInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)userID;
                this.db.GetReader(ref ResultDataReader, "SP_Mail_BySenderID", SqlParameters);
                while (ResultDataReader.Read())
                    mailInfoList.Add(this.InitMail(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return mailInfoList.ToArray();
        }

        public MailInfo GetMailSingle(int UserID, int mailID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
          new SqlParameter("@ID", (object) mailID),
          new SqlParameter("@UserID", (object) UserID)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Mail_Single", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitMail(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (MailInfo)null;
        }

        public bool SendMail(MailInfo mail)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[29];
                SqlParameters[0] = new SqlParameter("@ID", (object)mail.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Annex1", mail.Annex1 == null ? (object)"" : (object)mail.Annex1);
                SqlParameters[2] = new SqlParameter("@Annex2", mail.Annex2 == null ? (object)"" : (object)mail.Annex2);
                SqlParameters[3] = new SqlParameter("@Content", mail.Content == null ? (object)"" : (object)mail.Content);
                SqlParameters[4] = new SqlParameter("@Gold", (object)mail.Gold);
                SqlParameters[5] = new SqlParameter("@IsExist", (object)true);
                SqlParameters[6] = new SqlParameter("@Money", (object)mail.Money);
                SqlParameters[7] = new SqlParameter("@Receiver", mail.Receiver == null ? (object)"" : (object)mail.Receiver);
                SqlParameters[8] = new SqlParameter("@ReceiverID", (object)mail.ReceiverID);
                SqlParameters[9] = new SqlParameter("@Sender", mail.Sender == null ? (object)"" : (object)mail.Sender);
                SqlParameters[10] = new SqlParameter("@SenderID", (object)mail.SenderID);
                SqlParameters[11] = new SqlParameter("@Title", mail.Title == null ? (object)"" : (object)mail.Title);
                SqlParameters[12] = new SqlParameter("@IfDelS", (object)false);
                SqlParameters[13] = new SqlParameter("@IsDelete", (object)false);
                SqlParameters[14] = new SqlParameter("@IsDelR", (object)false);
                SqlParameters[15] = new SqlParameter("@IsRead", (object)false);
                SqlParameters[16] = new SqlParameter("@SendTime", (object)DateTime.Now);
                SqlParameters[17] = new SqlParameter("@Type", (object)mail.Type);
                SqlParameters[18] = new SqlParameter("@Annex1Name", mail.String_0 == null ? (object)"" : (object)mail.String_0);
                SqlParameters[19] = new SqlParameter("@Annex2Name", mail.String_1 == null ? (object)"" : (object)mail.String_1);
                SqlParameters[20] = new SqlParameter("@Annex3", mail.Annex3 == null ? (object)"" : (object)mail.Annex3);
                SqlParameters[21] = new SqlParameter("@Annex4", mail.Annex4 == null ? (object)"" : (object)mail.Annex4);
                SqlParameters[22] = new SqlParameter("@Annex5", mail.Annex5 == null ? (object)"" : (object)mail.Annex5);
                SqlParameters[23] = new SqlParameter("@Annex3Name", mail.String_2 == null ? (object)"" : (object)mail.String_2);
                SqlParameters[24] = new SqlParameter("@Annex4Name", mail.String_3 == null ? (object)"" : (object)mail.String_3);
                SqlParameters[25] = new SqlParameter("@Annex5Name", mail.String_4 == null ? (object)"" : (object)mail.String_4);
                SqlParameters[26] = new SqlParameter("@ValidDate", (object)mail.ValidDate);
                SqlParameters[27] = new SqlParameter("@AnnexRemark", mail.AnnexRemark == null ? (object)"" : (object)mail.AnnexRemark);
                SqlParameters[28] = new SqlParameter("GiftToken", (object)mail.GiftToken);
                flag = this.db.RunProcedure("SP_Mail_Send", SqlParameters);
                mail.ID = (int)SqlParameters[0].Value;
                using (CenterServiceClient centerServiceClient = new CenterServiceClient())
                    centerServiceClient.MailNotice(mail.ReceiverID);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool DeleteMail(int UserID, int mailID, out int senderID)
        {
            bool flag = false;
            senderID = 0;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[4]
                {
          new SqlParameter("@ID", (object) mailID),
          new SqlParameter("@UserID", (object) UserID),
          new SqlParameter("@SenderID", SqlDbType.Int),
          null
                };
                SqlParameters[2].Value = (object)senderID;
                SqlParameters[2].Direction = ParameterDirection.InputOutput;
                SqlParameters[3] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[3].Direction = ParameterDirection.ReturnValue;
                flag = this.db.RunProcedure("SP_Mail_Delete", SqlParameters);
                if ((int)SqlParameters[3].Value == 0)
                {
                    flag = true;
                    senderID = (int)SqlParameters[2].Value;
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateMail(MailInfo mail, int oldMoney)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[30]
                {
          new SqlParameter("@ID", (object) mail.ID),
          new SqlParameter("@Annex1", mail.Annex1 == null ? (object) "" : (object) mail.Annex1),
          new SqlParameter("@Annex2", mail.Annex2 == null ? (object) "" : (object) mail.Annex2),
          new SqlParameter("@Content", mail.Content == null ? (object) "" : (object) mail.Content),
          new SqlParameter("@Gold", (object) mail.Gold),
          new SqlParameter("@IsExist", (object) mail.IsExist),
          new SqlParameter("@Money", (object) mail.Money),
          new SqlParameter("@Receiver", mail.Receiver == null ? (object) "" : (object) mail.Receiver),
          new SqlParameter("@ReceiverID", (object) mail.ReceiverID),
          new SqlParameter("@Sender", mail.Sender == null ? (object) "" : (object) mail.Sender),
          new SqlParameter("@SenderID", (object) mail.SenderID),
          new SqlParameter("@Title", mail.Title == null ? (object) "" : (object) mail.Title),
          new SqlParameter("@IfDelS", (object) false),
          new SqlParameter("@IsDelete", (object) false),
          new SqlParameter("@IsDelR", (object) false),
          new SqlParameter("@IsRead", (object) mail.IsRead),
          new SqlParameter("@SendTime", (object) mail.SendTime),
          new SqlParameter("@Type", (object) mail.Type),
          new SqlParameter("@OldMoney", (object) oldMoney),
          new SqlParameter("@ValidDate", (object) mail.ValidDate),
          new SqlParameter("@Annex1Name", (object) mail.String_0),
          new SqlParameter("@Annex2Name", (object) mail.String_1),
          new SqlParameter("@Result", SqlDbType.Int),
          null,
          null,
          null,
          null,
          null,
          null,
          null
                };
                SqlParameters[22].Direction = ParameterDirection.ReturnValue;
                SqlParameters[23] = new SqlParameter("@Annex3", mail.Annex3 == null ? (object)"" : (object)mail.Annex3);
                SqlParameters[24] = new SqlParameter("@Annex4", mail.Annex4 == null ? (object)"" : (object)mail.Annex4);
                SqlParameters[25] = new SqlParameter("@Annex5", mail.Annex5 == null ? (object)"" : (object)mail.Annex5);
                SqlParameters[26] = new SqlParameter("@Annex3Name", mail.String_2 == null ? (object)"" : (object)mail.String_2);
                SqlParameters[27] = new SqlParameter("@Annex4Name", mail.String_3 == null ? (object)"" : (object)mail.String_3);
                SqlParameters[28] = new SqlParameter("@Annex5Name", mail.String_4 == null ? (object)"" : (object)mail.String_4);
                SqlParameters[29] = new SqlParameter("GiftToken", (object)mail.GiftToken);
                this.db.RunProcedure("SP_Mail_Update", SqlParameters);
                flag = (int)SqlParameters[22].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool CancelPaymentMail(int userid, int mailID, ref int senderID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[4]
                {
          new SqlParameter("@userid", (object) userid),
          new SqlParameter("@mailID", (object) mailID),
          new SqlParameter("@senderID", SqlDbType.Int),
          null
                };
                SqlParameters[2].Value = (object)senderID;
                SqlParameters[2].Direction = ParameterDirection.InputOutput;
                SqlParameters[3] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[3].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Mail_PaymentCancel", SqlParameters);
                if (flag = (int)SqlParameters[3].Value == 0)
                    senderID = (int)SqlParameters[2].Value;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool ScanMail(ref string noticeUserID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@NoticeUserID", SqlDbType.NVarChar, 4000)
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                this.db.RunProcedure("SP_Mail_Scan", SqlParameters);
                noticeUserID = SqlParameters[0].Value.ToString();
                flag = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool SendMailAndItem(MailInfo mail, SqlDataProvider.Data.ItemInfo item, ref int returnValue)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[34]
                {
          new SqlParameter("@ItemID", (object) item.ItemID),
          new SqlParameter("@UserID", (object) item.UserID),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Place", (object) item.Place),
          new SqlParameter("@AgilityCompose", (object) item.AgilityCompose),
          new SqlParameter("@AttackCompose", (object) item.AttackCompose),
          new SqlParameter("@BeginDate", (object) item.BeginDate),
          new SqlParameter("@Color", item.Color == null ? (object) "" : (object) item.Color),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@DefendCompose", (object) item.DefendCompose),
          new SqlParameter("@IsBinds", (object) item.IsBinds),
          new SqlParameter("@IsExist", (object) item.IsExist),
          new SqlParameter("@IsJudge", (object) item.IsJudge),
          new SqlParameter("@LuckCompose", (object) item.LuckCompose),
          new SqlParameter("@StrengthenLevel", (object) item.StrengthenLevel),
          new SqlParameter("@ValidDate", (object) item.ValidDate),
          new SqlParameter("@BagType", (object) item.BagType),
          new SqlParameter("@ID", (object) mail.ID),
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null
                };
                SqlParameters[17].Direction = ParameterDirection.Output;
                SqlParameters[18] = new SqlParameter("@Annex1", mail.Annex1 == null ? (object)"" : (object)mail.Annex1);
                SqlParameters[19] = new SqlParameter("@Annex2", mail.Annex2 == null ? (object)"" : (object)mail.Annex2);
                SqlParameters[20] = new SqlParameter("@Content", mail.Content == null ? (object)"" : (object)mail.Content);
                SqlParameters[21] = new SqlParameter("@Gold", (object)mail.Gold);
                SqlParameters[22] = new SqlParameter("@Money", (object)mail.Money);
                SqlParameters[23] = new SqlParameter("@Receiver", mail.Receiver == null ? (object)"" : (object)mail.Receiver);
                SqlParameters[24] = new SqlParameter("@ReceiverID", (object)mail.ReceiverID);
                SqlParameters[25] = new SqlParameter("@Sender", mail.Sender == null ? (object)"" : (object)mail.Sender);
                SqlParameters[26] = new SqlParameter("@SenderID", (object)mail.SenderID);
                SqlParameters[27] = new SqlParameter("@Title", mail.Title == null ? (object)"" : (object)mail.Title);
                SqlParameters[28] = new SqlParameter("@IfDelS", (object)false);
                SqlParameters[29] = new SqlParameter("@IsDelete", (object)false);
                SqlParameters[30] = new SqlParameter("@IsDelR", (object)false);
                SqlParameters[31] = new SqlParameter("@IsRead", (object)false);
                SqlParameters[32] = new SqlParameter("@SendTime", (object)DateTime.Now);
                SqlParameters[33] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[33].Direction = ParameterDirection.ReturnValue;
                flag = this.db.RunProcedure("SP_Admin_SendUserItem", SqlParameters);
                returnValue = (int)SqlParameters[33].Value;
                if (flag = returnValue == 0)
                {
                    using (CenterServiceClient centerServiceClient = new CenterServiceClient())
                        centerServiceClient.MailNotice(mail.ReceiverID);
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool SendMailAndMoney(MailInfo mail, ref int returnValue)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[18];
                SqlParameters[0] = new SqlParameter("@ID", (object)mail.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Annex1", mail.Annex1 == null ? (object)"" : (object)mail.Annex1);
                SqlParameters[2] = new SqlParameter("@Annex2", mail.Annex2 == null ? (object)"" : (object)mail.Annex2);
                SqlParameters[3] = new SqlParameter("@Content", mail.Content == null ? (object)"" : (object)mail.Content);
                SqlParameters[4] = new SqlParameter("@Gold", (object)mail.Gold);
                SqlParameters[5] = new SqlParameter("@IsExist", (object)true);
                SqlParameters[6] = new SqlParameter("@Money", (object)mail.Money);
                SqlParameters[7] = new SqlParameter("@Receiver", mail.Receiver == null ? (object)"" : (object)mail.Receiver);
                SqlParameters[8] = new SqlParameter("@ReceiverID", (object)mail.ReceiverID);
                SqlParameters[9] = new SqlParameter("@Sender", mail.Sender == null ? (object)"" : (object)mail.Sender);
                SqlParameters[10] = new SqlParameter("@SenderID", (object)mail.SenderID);
                SqlParameters[11] = new SqlParameter("@Title", mail.Title == null ? (object)"" : (object)mail.Title);
                SqlParameters[12] = new SqlParameter("@IfDelS", (object)false);
                SqlParameters[13] = new SqlParameter("@IsDelete", (object)false);
                SqlParameters[14] = new SqlParameter("@IsDelR", (object)false);
                SqlParameters[15] = new SqlParameter("@IsRead", (object)false);
                SqlParameters[16] = new SqlParameter("@SendTime", (object)DateTime.Now);
                SqlParameters[17] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[17].Direction = ParameterDirection.ReturnValue;
                flag = this.db.RunProcedure("SP_Admin_SendUserMoney", SqlParameters);
                returnValue = (int)SqlParameters[17].Value;
                flag = returnValue == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public int SendMailAndItem(
          string title,
          string content,
          int UserID,
          int templateID,
          int count,
          int validDate,
          int gold,
          int money,
          int StrengthenLevel,
          int AttackCompose,
          int DefendCompose,
          int AgilityCompose,
          int LuckCompose,
          bool isBinds)
        {
            MailInfo mail = new MailInfo();
            mail.Annex1 = "";
            mail.Content = title;
            mail.Gold = gold;
            mail.Money = money;
            mail.Receiver = "";
            mail.ReceiverID = UserID;
            mail.Sender = "Administrators";
            mail.SenderID = 0;
            mail.Title = content;
            SqlDataProvider.Data.ItemInfo itemInfo = new SqlDataProvider.Data.ItemInfo((ItemTemplateInfo)null);
            itemInfo.AgilityCompose = AgilityCompose;
            itemInfo.AttackCompose = AttackCompose;
            itemInfo.BeginDate = DateTime.Now;
            itemInfo.Color = "";
            itemInfo.DefendCompose = DefendCompose;
            itemInfo.IsDirty = false;
            itemInfo.IsExist = true;
            itemInfo.IsJudge = true;
            itemInfo.LuckCompose = LuckCompose;
            itemInfo.StrengthenLevel = StrengthenLevel;
            itemInfo.TemplateID = templateID;
            itemInfo.ValidDate = validDate;
            itemInfo.Count = count;
            itemInfo.IsBinds = isBinds;
            int returnValue = 1;
            this.SendMailAndItem(mail, itemInfo, ref returnValue);
            return returnValue;
        }

        public int SendMailAndItemByUserName(
          string title,
          string content,
          string userName,
          int templateID,
          int count,
          int validDate,
          int gold,
          int money,
          int StrengthenLevel,
          int AttackCompose,
          int DefendCompose,
          int AgilityCompose,
          int LuckCompose,
          bool isBinds)
        {
            PlayerInfo singleByUserName = this.GetUserSingleByUserName(userName);
            return singleByUserName != null ? this.SendMailAndItem(title, content, singleByUserName.ID, templateID, count, validDate, gold, money, StrengthenLevel, AttackCompose, DefendCompose, AgilityCompose, LuckCompose, isBinds) : 2;
        }

        public int SendMailAndItemByNickName(
          string title,
          string content,
          string NickName,
          int templateID,
          int count,
          int validDate,
          int gold,
          int money,
          int StrengthenLevel,
          int AttackCompose,
          int DefendCompose,
          int AgilityCompose,
          int LuckCompose,
          bool isBinds)
        {
            PlayerInfo singleByNickName = this.GetUserSingleByNickName(NickName);
            return singleByNickName != null ? this.SendMailAndItem(title, content, singleByNickName.ID, templateID, count, validDate, gold, money, StrengthenLevel, AttackCompose, DefendCompose, AgilityCompose, LuckCompose, isBinds) : 2;
        }

        public int SendMailAndItem(
          string title,
          string content,
          int userID,
          int gold,
          int money,
          string param)
        {
            int num = 1;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[8]
                {
          new SqlParameter("@Title", (object) title),
          new SqlParameter("@Content", (object) content),
          new SqlParameter("@UserID", (object) userID),
          new SqlParameter("@Gold", (object) gold),
          new SqlParameter("@Money", (object) money),
          new SqlParameter("@GiftToken", SqlDbType.BigInt),
          new SqlParameter("@Param", (object) param),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[7].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Admin_SendAllItem", SqlParameters);
                num = (int)SqlParameters[7].Value;
                if (num == 0)
                {
                    using (CenterServiceClient centerServiceClient = new CenterServiceClient())
                        centerServiceClient.MailNotice(userID);
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return num;
        }

        public int SendMailAndItemByUserName(
          string title,
          string content,
          string userName,
          int gold,
          int money,
          string param)
        {
            PlayerInfo singleByUserName = this.GetUserSingleByUserName(userName);
            return singleByUserName != null ? this.SendMailAndItem(title, content, singleByUserName.ID, gold, money, param) : 2;
        }

        public int SendMailAndItemByNickName(
          string title,
          string content,
          string nickName,
          int gold,
          int money,
          string param)
        {
            PlayerInfo singleByNickName = this.GetUserSingleByNickName(nickName);
            return singleByNickName != null ? this.SendMailAndItem(title, content, singleByNickName.ID, gold, money, param) : 2;
        }

        public Dictionary<int, int> GetFriendsIDAll(int UserID)
        {
            Dictionary<int, int> friendsIdAll = new Dictionary<int, int>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Users_Friends_All", SqlParameters);
                while (ResultDataReader.Read())
                {
                    if (!friendsIdAll.ContainsKey((int)ResultDataReader["FriendID"]))
                        friendsIdAll.Add((int)ResultDataReader["FriendID"], (int)ResultDataReader["Relation"]);
                    else
                        friendsIdAll[(int)ResultDataReader["FriendID"]] = (int)ResultDataReader["Relation"];
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return friendsIdAll;
        }

        public bool AddFriends(FriendInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Users_Friends_Add", new SqlParameter[7]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@AddDate", (object) DateTime.Now),
          new SqlParameter("@FriendID", (object) info.FriendID),
          new SqlParameter("@IsExist", (object) true),
          new SqlParameter("@Remark", info.Remark == null ? (object) "" : (object) info.Remark),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@Relation", (object) info.Relation)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool DeleteFriends(int UserID, int FriendID)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Users_Friends_Delete", new SqlParameter[2]
                {
          new SqlParameter("@ID", (object) FriendID),
          new SqlParameter("@UserID", (object) UserID)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public FriendInfo[] GetFriendsAll(int UserID)
        {
            List<FriendInfo> friendInfoList = new List<FriendInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Users_Friends", SqlParameters);
                while (ResultDataReader.Read())
                {
                    FriendInfo friendInfo = new FriendInfo();
                    friendInfo.AddDate = (DateTime)ResultDataReader["AddDate"];
                    friendInfo.FriendID = (int)ResultDataReader["FriendID"];
                    friendInfo.ID = (int)ResultDataReader["ID"];
                    friendInfo.IsExist = (bool)ResultDataReader["IsExist"];
                    friendInfo.NickName = ResultDataReader["NickName"] == null ? "" : ResultDataReader["NickName"].ToString();
                    if (!string.IsNullOrEmpty(friendInfo.NickName))
                    {
                        friendInfo.Grade = (int)ResultDataReader["Grade"];
                        friendInfo.Hide = (int)ResultDataReader["Hide"];
                        friendInfo.Remark = ResultDataReader["Remark"] == null ? "" : ResultDataReader["Remark"].ToString();
                        friendInfo.Sex = (bool)ResultDataReader["Sex"] ? 1 : 0;
                        friendInfo.State = (int)ResultDataReader["State"];
                        friendInfo.Colors = ResultDataReader["Colors"] == null ? "" : ResultDataReader["Colors"].ToString();
                        friendInfo.Style = ResultDataReader["Style"] == null ? "" : ResultDataReader["Style"].ToString();
                        friendInfo.UserID = (int)ResultDataReader[nameof(UserID)];
                        friendInfo.ConsortiaName = ResultDataReader["ConsortiaName"] == null ? "" : ResultDataReader["ConsortiaName"].ToString();
                        friendInfo.Offer = (int)ResultDataReader["Offer"];
                        friendInfo.Win = (int)ResultDataReader["Win"];
                        friendInfo.Total = (int)ResultDataReader["Total"];
                        friendInfo.Escape = (int)ResultDataReader["Escape"];
                        friendInfo.Relation = (int)ResultDataReader["Relation"];
                        friendInfo.Repute = (int)ResultDataReader["Repute"];
                        friendInfo.UserName = ResultDataReader["UserName"] == null ? "" : ResultDataReader["UserName"].ToString();
                        friendInfo.DutyName = ResultDataReader["DutyName"] == null ? "" : ResultDataReader["DutyName"].ToString();
                        friendInfo.Nimbus = (int)ResultDataReader["Nimbus"];
                        friendInfo.typeVIP = Convert.ToByte(ResultDataReader["typeVIP"]);
                        friendInfo.VIPLevel = (int)ResultDataReader["VIPLevel"];
                        friendInfo.IsMarried = (bool)ResultDataReader["IsMarried"];
                        friendInfo.LastDate = (DateTime)ResultDataReader["LastDate"];
                        friendInfo.FightPower = (int)ResultDataReader["FightPower"];
                        friendInfoList.Add(friendInfo);
                    }
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)("Init " + (object)UserID), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return friendInfoList.ToArray();
        }

        public ArrayList GetFriendsGood(string UserName)
        {
            ArrayList friendsGood = new ArrayList();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserName", SqlDbType.NVarChar)
                };
                SqlParameters[0].Value = (object)UserName;
                this.db.GetReader(ref ResultDataReader, "SP_Users_Friends_Good", SqlParameters);
                while (ResultDataReader.Read())
                    friendsGood.Add(ResultDataReader[nameof(UserName)] == null ? (object)"" : (object)ResultDataReader[nameof(UserName)].ToString());
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return friendsGood;
        }

        public FriendInfo[] GetFriendsBbs(string condictArray)
        {
            List<FriendInfo> friendInfoList = new List<FriendInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@SearchUserName", SqlDbType.NVarChar, 4000)
                };
                SqlParameters[0].Value = (object)condictArray;
                this.db.GetReader(ref ResultDataReader, "SP_Users_FriendsBbs", SqlParameters);
                while (ResultDataReader.Read())
                    friendInfoList.Add(new FriendInfo()
                    {
                        NickName = ResultDataReader["NickName"] == null ? "" : ResultDataReader["NickName"].ToString(),
                        UserID = (int)ResultDataReader["UserID"],
                        UserName = ResultDataReader["UserName"] == null ? "" : ResultDataReader["UserName"].ToString(),
                        IsExist = (int)ResultDataReader["UserID"] > 0
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return friendInfoList.ToArray();
        }

        public QuestDataInfo[] GetUserQuest(int userID)
        {
            List<QuestDataInfo> questDataInfoList = new List<QuestDataInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)userID;
                this.db.GetReader(ref ResultDataReader, "SP_QuestData_All", SqlParameters);
                while (ResultDataReader.Read())
                    questDataInfoList.Add(new QuestDataInfo()
                    {
                        CompletedDate = (DateTime)ResultDataReader["CompletedDate"],
                        IsComplete = (bool)ResultDataReader["IsComplete"],
                        Condition1 = (int)ResultDataReader["Condition1"],
                        Condition2 = (int)ResultDataReader["Condition2"],
                        Condition3 = (int)ResultDataReader["Condition3"],
                        Condition4 = (int)ResultDataReader["Condition4"],
                        Condition5 = (int)ResultDataReader["Condition5"],
                        Condition6 = (int)ResultDataReader["Condition6"],
                        Condition7 = (int)ResultDataReader["Condition7"],
                        Condition8 = (int)ResultDataReader["Condition8"],
                        QuestID = (int)ResultDataReader["QuestID"],
                        UserID = (int)ResultDataReader["UserId"],
                        IsExist = (bool)ResultDataReader["IsExist"],
                        RandDobule = (int)ResultDataReader["RandDobule"],
                        RepeatFinish = (int)ResultDataReader["RepeatFinish"],
                        QuestLevel = (int)ResultDataReader["QuestLevel"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return questDataInfoList.ToArray();
        }

        public bool UpdateDbQuestDataInfo(QuestDataInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_QuestData_Add", new SqlParameter[16]
                {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@QuestID", (object) info.QuestID),
          new SqlParameter("@CompletedDate", (object) info.CompletedDate),
          new SqlParameter("@IsComplete", (object) info.IsComplete),
          new SqlParameter("@Condition1", (object) info.Condition1),
          new SqlParameter("@Condition2", (object) info.Condition2),
          new SqlParameter("@Condition3", (object) info.Condition3),
          new SqlParameter("@Condition4", (object) info.Condition4),
          new SqlParameter("@Condition5", (object) info.Condition5),
          new SqlParameter("@Condition6", (object) info.Condition6),
          new SqlParameter("@Condition7", (object) info.Condition7),
          new SqlParameter("@Condition8", (object) info.Condition8),
          new SqlParameter("@IsExist", (object) info.IsExist),
          new SqlParameter("@RepeatFinish", (object) info.RepeatFinish),
          new SqlParameter("@RandDobule", (object) info.RandDobule),
          new SqlParameter("@QuestLevel", (object) info.QuestLevel)
                });
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public BufferInfo[] GetUserBuffer(int userID)
        {
            List<BufferInfo> bufferInfoList1 = new List<BufferInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)userID;
                this.db.GetReader(ref ResultDataReader, "SP_User_Buff_All", SqlParameters);
                while (ResultDataReader.Read())
                {
                    List<BufferInfo> bufferInfoList2 = bufferInfoList1;
                    BufferInfo bufferInfo1 = new BufferInfo();
                    bufferInfo1.BeginDate = (DateTime)ResultDataReader["BeginDate"];
                    bufferInfo1.Data = ResultDataReader["Data"] == null ? "" : ResultDataReader["Data"].ToString();
                    bufferInfo1.Type = (int)ResultDataReader["Type"];
                    bufferInfo1.UserID = (int)ResultDataReader["UserID"];
                    bufferInfo1.ValidDate = (int)ResultDataReader["ValidDate"];
                    bufferInfo1.Value = (int)ResultDataReader["Value"];
                    bufferInfo1.IsExist = (bool)ResultDataReader["IsExist"];
                    bufferInfo1.ValidCount = (int)ResultDataReader["ValidCount"];
                    bufferInfo1.TemplateID = (int)ResultDataReader["TemplateID"];
                    bufferInfo1.IsDirty = false;
                    BufferInfo bufferInfo2 = bufferInfo1;
                    bufferInfoList2.Add(bufferInfo2);
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return bufferInfoList1.ToArray();
        }

        public ConsortiaBufferInfo[] GetUserConsortiaBuffer(int ConsortiaID)
        {
            List<ConsortiaBufferInfo> consortiaBufferInfoList = new List<ConsortiaBufferInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ConsortiaID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)ConsortiaID;
                this.db.GetReader(ref ResultDataReader, "SP_User_Consortia_Buff_All", SqlParameters);
                while (ResultDataReader.Read())
                    consortiaBufferInfoList.Add(new ConsortiaBufferInfo()
                    {
                        ConsortiaID = (int)ResultDataReader[nameof(ConsortiaID)],
                        BufferID = (int)ResultDataReader["BufferID"],
                        IsOpen = (bool)ResultDataReader["IsOpen"],
                        BeginDate = (DateTime)ResultDataReader["BeginDate"],
                        ValidDate = (int)ResultDataReader["ValidDate"],
                        Type = (int)ResultDataReader["Type"],
                        Value = (int)ResultDataReader["Value"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init SP_User_Consortia_Buff_All", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return consortiaBufferInfoList.ToArray();
        }

        public ConsortiaBufferInfo GetUserConsortiaBufferSingle(int ID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)ID;
                this.db.GetReader(ref ResultDataReader, "SP_User_Consortia_Buff_Single", SqlParameters);
                if (ResultDataReader.Read())
                    return new ConsortiaBufferInfo()
                    {
                        ConsortiaID = (int)ResultDataReader["ConsortiaID"],
                        BufferID = (int)ResultDataReader["BufferID"],
                        IsOpen = (bool)ResultDataReader["IsOpen"],
                        BeginDate = (DateTime)ResultDataReader["BeginDate"],
                        ValidDate = (int)ResultDataReader["ValidDate"],
                        Type = (int)ResultDataReader["Type"],
                        Value = (int)ResultDataReader["Value"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init SP_User_Consortia_Buff_Single", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (ConsortiaBufferInfo)null;
        }

        public bool SaveBuffer(BufferInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_User_Buff_Add", new SqlParameter[9]
                {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@Type", (object) info.Type),
          new SqlParameter("@BeginDate", (object) info.BeginDate),
          new SqlParameter("@Data", info.Data == null ? (object) "" : (object) info.Data),
          new SqlParameter("@IsExist", (object) info.IsExist),
          new SqlParameter("@ValidDate", (object) info.ValidDate),
          new SqlParameter("@ValidCount", (object) info.ValidCount),
          new SqlParameter("@Value", (object) info.Value),
          new SqlParameter("@TemplateID", (object) info.TemplateID)
                });
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool SaveConsortiaBuffer(ConsortiaBufferInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_User_Consortia_Buff_Add", new SqlParameter[7]
                {
          new SqlParameter("@ConsortiaID", (object) info.ConsortiaID),
          new SqlParameter("@BufferID", (object) info.BufferID),
          new SqlParameter("@IsOpen", (object) info.IsOpen),
          new SqlParameter("@BeginDate", (object) info.BeginDate),
          new SqlParameter("@ValidDate", (object) info.ValidDate),
          new SqlParameter("@Type ", (object) info.Type),
          new SqlParameter("@Value", (object) info.Value)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public LuckStarRewardRecordInfo[] GetLuckStarTopTenRank(int MinUseNum)
        {
            List<LuckStarRewardRecordInfo> rewardRecordInfoList = new List<LuckStarRewardRecordInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            int num = 1;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@MinUseNum", (object) MinUseNum)
                };
                this.db.GetReader(ref ResultDataReader, "SP_LuckStar_Reward_Record_All", SqlParameters);
                while (ResultDataReader.Read())
                {
                    rewardRecordInfoList.Add(new LuckStarRewardRecordInfo()
                    {
                        PlayerID = (int)ResultDataReader["UserID"],
                        useStarNum = (int)ResultDataReader["useStarNum"],
                        isVip = (int)ResultDataReader["isVip"],
                        nickName = (string)ResultDataReader["nickName"],
                        rank = num
                    });
                    ++num;
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init SP_LuckStar_Reward_Record_All", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return rewardRecordInfoList.ToArray();
        }

        public bool SaveLuckStarRankInfo(LuckStarRewardRecordInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_LuckStar_Rank_Info_Add", new SqlParameter[4]
                {
          new SqlParameter("@UserID", (object) info.PlayerID),
          new SqlParameter("@useStarNum", (object) info.useStarNum),
          new SqlParameter("@nickName", (object) info.nickName),
          new SqlParameter("@isVip", (object) info.isVip)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool ResetLuckStarRank()
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Reset_LuckStar_Rank_Info");
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init ResetLuckStar", ex);
            }
            return flag;
        }

        public bool AddChargeMoney(
          string chargeID,
          string userName,
          int money,
          string payWay,
          Decimal needMoney,
          out int userID,
          ref int isResult,
          DateTime date,
          string IP,
          string nickName)
        {
            bool flag = false;
            userID = 0;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[10]
                {
          new SqlParameter("@ChargeID", (object) chargeID),
          new SqlParameter("@UserName", (object) userName),
          new SqlParameter("@Money", (object) money),
          new SqlParameter("@Date", (object) date.ToString("yyyy-MM-dd HH:mm:ss")),
          new SqlParameter("@PayWay", (object) payWay),
          new SqlParameter("@NeedMoney", (object) needMoney),
          new SqlParameter("@UserID", (object) userID),
          null,
          null,
          null
                };
                SqlParameters[6].Direction = ParameterDirection.InputOutput;
                SqlParameters[7] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[7].Direction = ParameterDirection.ReturnValue;
                SqlParameters[8] = new SqlParameter("@IP", (object)IP);
                SqlParameters[9] = new SqlParameter("@NickName", (object)nickName);
                flag = this.db.RunProcedure("SP_Charge_Money_Add", SqlParameters);
                userID = (int)SqlParameters[6].Value;
                isResult = (int)SqlParameters[7].Value;
                flag = isResult == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool ChargeToUser(string userName, ref int money, string nickName)
        {
            bool user = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[3]
                {
          new SqlParameter("@UserName", (object) userName),
          new SqlParameter("@money", SqlDbType.Int),
          null
                };
                SqlParameters[1].Direction = ParameterDirection.Output;
                SqlParameters[2] = new SqlParameter("@NickName", (object)nickName);
                user = this.db.RunProcedure("SP_Charge_To_User", SqlParameters);
                money = (int)SqlParameters[1].Value;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return user;
        }

        public ChargeRecordInfo[] GetChargeRecordInfo(DateTime date, int SaveRecordSecond)
        {
            List<ChargeRecordInfo> chargeRecordInfoList = new List<ChargeRecordInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
          new SqlParameter("@Date", (object) date.ToString("yyyy-MM-dd HH:mm:ss")),
          new SqlParameter("@Second", (object) SaveRecordSecond)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Charge_Record", SqlParameters);
                while (ResultDataReader.Read())
                    chargeRecordInfoList.Add(new ChargeRecordInfo()
                    {
                        BoyTotalPay = (int)ResultDataReader["BoyTotalPay"],
                        GirlTotalPay = (int)ResultDataReader["GirlTotalPay"],
                        PayWay = ResultDataReader["PayWay"] == null ? "" : ResultDataReader["PayWay"].ToString(),
                        TotalBoy = (int)ResultDataReader["TotalBoy"],
                        TotalGirl = (int)ResultDataReader["TotalGirl"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return chargeRecordInfoList.ToArray();
        }

        public AuctionInfo GetAuctionSingle(int auctionID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@AuctionID", (object) auctionID)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Auction_Single", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitAuctionInfo(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (AuctionInfo)null;
        }

        public bool AddAuction(AuctionInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[18];
                SqlParameters[0] = new SqlParameter("@AuctionID", (object)info.AuctionID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@AuctioneerID", (object)info.AuctioneerID);
                SqlParameters[2] = new SqlParameter("@AuctioneerName", info.AuctioneerName == null ? (object)"" : (object)info.AuctioneerName);
                SqlParameters[3] = new SqlParameter("@BeginDate", (object)info.BeginDate);
                SqlParameters[4] = new SqlParameter("@BuyerID", (object)info.BuyerID);
                SqlParameters[5] = new SqlParameter("@BuyerName", info.BuyerName == null ? (object)"" : (object)info.BuyerName);
                SqlParameters[6] = new SqlParameter("@IsExist", (object)info.IsExist);
                SqlParameters[7] = new SqlParameter("@ItemID", (object)info.ItemID);
                SqlParameters[8] = new SqlParameter("@Mouthful", (object)info.Mouthful);
                SqlParameters[9] = new SqlParameter("@PayType", (object)info.PayType);
                SqlParameters[10] = new SqlParameter("@Price", (object)info.Price);
                SqlParameters[11] = new SqlParameter("@Rise", (object)info.Rise);
                SqlParameters[12] = new SqlParameter("@ValidDate", (object)info.ValidDate);
                SqlParameters[13] = new SqlParameter("@TemplateID", (object)info.TemplateID);
                SqlParameters[14] = new SqlParameter("Name", (object)info.Name);
                SqlParameters[15] = new SqlParameter("Category", (object)info.Category);
                SqlParameters[16] = new SqlParameter("Random", (object)info.Random);
                SqlParameters[17] = new SqlParameter("goodsCount", (object)info.goodsCount);
                flag = this.db.RunProcedure("SP_Auction_Add", SqlParameters);
                info.AuctionID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateAuction(AuctionInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[16]
                {
          new SqlParameter("@AuctionID", (object) info.AuctionID),
          new SqlParameter("@AuctioneerID", (object) info.AuctioneerID),
          new SqlParameter("@AuctioneerName", info.AuctioneerName == null ? (object) "" : (object) info.AuctioneerName),
          new SqlParameter("@BeginDate", (object) info.BeginDate),
          new SqlParameter("@BuyerID", (object) info.BuyerID),
          new SqlParameter("@BuyerName", info.BuyerName == null ? (object) "" : (object) info.BuyerName),
          new SqlParameter("@IsExist", (object) info.IsExist),
          new SqlParameter("@ItemID", (object) info.ItemID),
          new SqlParameter("@Mouthful", (object) info.Mouthful),
          new SqlParameter("@PayType", (object) info.PayType),
          new SqlParameter("@Price", (object) info.Price),
          new SqlParameter("@Rise", (object) info.Rise),
          new SqlParameter("@ValidDate", (object) info.ValidDate),
          new SqlParameter("Name", (object) info.Name),
          new SqlParameter("Category", (object) info.Category),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[15].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Auction_Update", SqlParameters);
                flag = (int)SqlParameters[15].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool DeleteAuction(int auctionID, int userID, ref string msg)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[3]
                {
          new SqlParameter("@AuctionID", (object) auctionID),
          new SqlParameter("@UserID", (object) userID),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[2].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Auction_Delete", SqlParameters);
                int num = (int)SqlParameters[2].Value;
                flag = num == 0;
                switch (num)
                {
                    case 0:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.DeleteAuction.Msg1");
                        break;
                    case 1:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.DeleteAuction.Msg2");
                        break;
                    case 2:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.DeleteAuction.Msg3");
                        break;
                    default:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.DeleteAuction.Msg4");
                        break;
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public AuctionInfo[] GetAuctionPage(
          int page,
          string name,
          int type,
          int pay,
          ref int total,
          int userID,
          int buyID,
          int order,
          bool sort,
          int size,
          string string_0)
        {
            List<AuctionInfo> auctionInfoList = new List<AuctionInfo>();
            try
            {
                string str1 = " IsExist=1 ";
                if (!string.IsNullOrEmpty(name))
                    str1 = str1 + " and Name like '%" + name + "%' ";
                switch (type)
                {
                    case -1:
                        if (pay != -1)
                            str1 = str1 + " and PayType =" + (object)pay + " ";
                        if (userID != -1)
                            str1 = str1 + " and AuctioneerID =" + (object)userID + " ";
                        if (buyID != -1)
                            str1 = str1 + " and (BuyerID =" + (object)buyID + " or AuctionID in (" + string_0 + ")) ";
                        string str2 = "Category,Name,Price,dd,AuctioneerID";
                        switch (order)
                        {
                            case 0:
                                str2 = "Name";
                                break;
                            case 2:
                                str2 = "dd";
                                break;
                            case 3:
                                str2 = "AuctioneerName";
                                break;
                            case 4:
                                str2 = "Price";
                                break;
                            case 5:
                                str2 = "BuyerName";
                                break;
                        }
                        string str3 = str2 + (sort ? " desc" : "") + ",AuctionID ";
                        SqlParameter[] SqlParameters = new SqlParameter[8]
                        {
              new SqlParameter("@QueryStr", (object) "V_Auction_Scan"),
              new SqlParameter("@QueryWhere", (object) str1),
              new SqlParameter("@PageSize", (object) size),
              new SqlParameter("@PageCurrent", (object) page),
              new SqlParameter("@FdShow", (object) "*"),
              new SqlParameter("@FdOrder", (object) str3),
              new SqlParameter("@FdKey", (object) "AuctionID"),
              new SqlParameter("@TotalRow", (object) total)
                        };
                        SqlParameters[7].Direction = ParameterDirection.Output;
                        DataTable dataTable = this.db.GetDataTable("Auction", "SP_CustomPage", SqlParameters);
                        total = (int)SqlParameters[7].Value;
                        IEnumerator enumerator = dataTable.Rows.GetEnumerator();
                        try
                        {
                            while (enumerator.MoveNext())
                            {
                                DataRow current = (DataRow)enumerator.Current;
                                auctionInfoList.Add(new AuctionInfo()
                                {
                                    AuctioneerID = (int)current["AuctioneerID"],
                                    AuctioneerName = current["AuctioneerName"].ToString(),
                                    AuctionID = (int)current["AuctionID"],
                                    BeginDate = (DateTime)current["BeginDate"],
                                    BuyerID = (int)current["BuyerID"],
                                    BuyerName = current["BuyerName"].ToString(),
                                    Category = (int)current["Category"],
                                    IsExist = (bool)current["IsExist"],
                                    ItemID = (int)current["ItemID"],
                                    Name = current["Name"].ToString(),
                                    Mouthful = (int)current["Mouthful"],
                                    PayType = (int)current["PayType"],
                                    Price = (int)current["Price"],
                                    Rise = (int)current["Rise"],
                                    ValidDate = (int)current["ValidDate"],
                                    goodsCount = (int)current["dd"]
                                });
                            }
                            break;
                        }
                        finally
                        {
                            if (enumerator is IDisposable disposable)
                                disposable.Dispose();
                        }
                    case 0:
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5:
                    case 6:
                    case 7:
                    case 8:
                    case 9:
                    case 10:
                    case 11:
                    case 12:
                    case 13:
                    case 14:
                    case 15:
                    case 16:
                    case 17:
                        str1 = str1 + " and Category =" + (object)type + " ";
                        goto default;
                    case 21:
                        str1 += " and Category in(1,2,5,8,9) ";
                        goto default;
                    case 22:
                        str1 += " and Category in(13,15,6,4,3) ";
                        goto default;
                    case 23:
                        str1 += " and Category in(16,11,10) ";
                        goto default;
                    case 24:
                        str1 += " and Category in(8,9) ";
                        goto default;
                    case 25:
                        str1 += " and Category in (7,17) ";
                        goto default;
                    case 26:
                        str1 += " and TemplateId>=311000 and TemplateId<=313999";
                        goto default;
                    case 27:
                        str1 += " and TemplateId>=311000 and TemplateId<=311999 ";
                        goto default;
                    case 28:
                        str1 += " and TemplateId>=312000 and TemplateId<=312999 ";
                        goto default;
                    case 29:
                        str1 += " and TemplateId>=313000 and TempLateId<=313999";
                        goto default;
                    case 1100:
                        str1 += " and TemplateID in (11019,11021,11022,11023) ";
                        goto default;
                    case 1101:
                        str1 += " and TemplateID='11019' ";
                        goto default;
                    case 1102:
                        str1 += " and TemplateID='11021' ";
                        goto default;
                    case 1103:
                        str1 += " and TemplateID='11022' ";
                        goto default;
                    case 1104:
                        str1 += " and TemplateID='11023' ";
                        goto default;
                    case 1105:
                        str1 += " and TemplateID in (11001,11002,11003,11004,11005,11006,11007,11008,11009,11010,11011,11012,11013,11014,11015,11016) ";
                        goto default;
                    case 1106:
                        str1 += " and TemplateID in (11001,11002,11003,11004) ";
                        goto default;
                    case 1107:
                        str1 += " and TemplateID in (11005,11006,11007,11008) ";
                        goto default;
                    case 1108:
                        str1 += " and TemplateID in (11009,11010,11011,11012) ";
                        goto default;
                    case 1109:
                        str1 += " and TemplateID in (11013,11014,11015,11016) ";
                        goto default;
                    default:
                        goto case -1;
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return auctionInfoList.ToArray();
        }

        public AuctionInfo InitAuctionInfo(SqlDataReader reader)
        {
            return new AuctionInfo()
            {
                AuctioneerID = (int)reader["AuctioneerID"],
                AuctioneerName = reader["AuctioneerName"] == null ? "" : reader["AuctioneerName"].ToString(),
                AuctionID = (int)reader["AuctionID"],
                BeginDate = (DateTime)reader["BeginDate"],
                BuyerID = (int)reader["BuyerID"],
                BuyerName = reader["BuyerName"] == null ? "" : reader["BuyerName"].ToString(),
                IsExist = (bool)reader["IsExist"],
                ItemID = (int)reader["ItemID"],
                Mouthful = (int)reader["Mouthful"],
                PayType = (int)reader["PayType"],
                Price = (int)reader["Price"],
                Rise = (int)reader["Rise"],
                ValidDate = (int)reader["ValidDate"],
                Name = reader["Name"].ToString(),
                Category = (int)reader["Category"],
                goodsCount = (int)reader["goodsCount"]
            };
        }

        public bool ScanAuction(ref string noticeUserID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@NoticeUserID", SqlDbType.NVarChar, 4000)
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                this.db.RunProcedure("SP_Auction_Scan", SqlParameters);
                noticeUserID = SqlParameters[0].Value.ToString();
                flag = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool AddMarryInfo(MarryInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[5]
                {
          new SqlParameter("@ID", (object) info.ID),
          null,
          null,
          null,
          null
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)info.UserID);
                SqlParameters[2] = new SqlParameter("@IsPublishEquip", (object)info.IsPublishEquip);
                SqlParameters[3] = new SqlParameter("@Introduction", (object)info.Introduction);
                SqlParameters[4] = new SqlParameter("@RegistTime", (object)info.RegistTime);
                flag = this.db.RunProcedure("SP_MarryInfo_Add", SqlParameters);
                info.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(AddMarryInfo), ex);
            }
            return flag;
        }

        public bool DeleteMarryInfo(int ID, int userID, ref string msg)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[3]
                {
          new SqlParameter("@ID", (object) ID),
          new SqlParameter("@UserID", (object) userID),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[2].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_MarryInfo_Delete", SqlParameters);
                int num = (int)SqlParameters[2].Value;
                flag = num == 0;
                if (num == 0)
                    msg = LanguageMgr.GetTranslation("PlayerBussiness.DeleteAuction.Succeed");
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"DeleteAuction", ex);
            }
            return flag;
        }

        public MarryInfo GetMarryInfoSingle(int ID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) ID)
                };
                this.db.GetReader(ref ResultDataReader, "SP_MarryInfo_Single", SqlParameters);
                if (ResultDataReader.Read())
                    return new MarryInfo()
                    {
                        ID = (int)ResultDataReader[nameof(ID)],
                        UserID = (int)ResultDataReader["UserID"],
                        IsPublishEquip = (bool)ResultDataReader["IsPublishEquip"],
                        Introduction = ResultDataReader["Introduction"].ToString(),
                        RegistTime = (DateTime)ResultDataReader["RegistTime"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetMarryInfoSingle), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (MarryInfo)null;
        }

        public bool UpdateMarryInfo(MarryInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[6]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@IsPublishEquip", (object) info.IsPublishEquip),
          new SqlParameter("@Introduction", (object) info.Introduction),
          new SqlParameter("@RegistTime", (object) info.RegistTime),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[5].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_MarryInfo_Update", SqlParameters);
                flag = (int)SqlParameters[5].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public MarryInfo[] GetMarryInfoPage(int page, string name, bool sex, int size, ref int total)
        {
            List<MarryInfo> marryInfoList = new List<MarryInfo>();
            try
            {
                string str1 = !sex ? " IsExist=1 and Sex=0 and UserExist=1" : " IsExist=1 and Sex=1 and UserExist=1";
                if (!string.IsNullOrEmpty(name))
                    str1 = str1 + " and NickName like '%" + name + "%' ";
                string str2 = "State desc,IsMarried";
                SqlParameter[] SqlParameters = new SqlParameter[8]
                {
          new SqlParameter("@QueryStr", (object) "V_Sys_Marry_Info"),
          new SqlParameter("@QueryWhere", (object) str1),
          new SqlParameter("@PageSize", (object) size),
          new SqlParameter("@PageCurrent", (object) page),
          new SqlParameter("@FdShow", (object) "*"),
          new SqlParameter("@FdOrder", (object) str2),
          new SqlParameter("@FdKey", (object) "ID"),
          new SqlParameter("@TotalRow", (object) total)
                };
                SqlParameters[7].Direction = ParameterDirection.Output;
                DataTable dataTable = this.db.GetDataTable("V_Sys_Marry_Info", "SP_CustomPage", SqlParameters);
                total = (int)SqlParameters[7].Value;
                foreach (DataRow row in (InternalDataCollectionBase)dataTable.Rows)
                    marryInfoList.Add(new MarryInfo()
                    {
                        ID = (int)row["ID"],
                        UserID = (int)row["UserID"],
                        IsPublishEquip = (bool)row["IsPublishEquip"],
                        Introduction = row["Introduction"].ToString(),
                        NickName = row["NickName"].ToString(),
                        IsConsortia = (bool)row["IsConsortia"],
                        ConsortiaID = (int)row["ConsortiaID"],
                        Sex = (bool)row["Sex"],
                        Win = (int)row["Win"],
                        Total = (int)row["Total"],
                        Escape = (int)row["Escape"],
                        GP = (int)row["GP"],
                        Honor = row["Honor"].ToString(),
                        Style = row["Style"].ToString(),
                        Colors = row["Colors"].ToString(),
                        Hide = (int)row["Hide"],
                        Grade = (int)row["Grade"],
                        State = (int)row["State"],
                        Repute = (int)row["Repute"],
                        Skin = row["Skin"].ToString(),
                        Offer = (int)row["Offer"],
                        IsMarried = (bool)row["IsMarried"],
                        ConsortiaName = row["ConsortiaName"].ToString(),
                        DutyName = row["DutyName"].ToString(),
                        Nimbus = (int)row["Nimbus"],
                        FightPower = (int)row["FightPower"],
                        typeVIP = Convert.ToByte(row["typeVIP"]),
                        VIPLevel = (int)row["VIPLevel"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return marryInfoList.ToArray();
        }

        public bool InsertPlayerMarryApply(MarryApplyInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[7]
                {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@ApplyUserID", (object) info.ApplyUserID),
          new SqlParameter("@ApplyUserName", (object) info.ApplyUserName),
          new SqlParameter("@ApplyType", (object) info.ApplyType),
          new SqlParameter("@ApplyResult", (object) info.ApplyResult),
          new SqlParameter("@LoveProclamation", (object) info.LoveProclamation),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[6].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Insert_Marry_Apply", SqlParameters);
                flag = (int)SqlParameters[6].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(InsertPlayerMarryApply), ex);
            }
            return flag;
        }

        public bool UpdatePlayerMarryApply(int UserID, string loveProclamation, bool isExist)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[4]
                {
          new SqlParameter("@UserID", (object) UserID),
          new SqlParameter("@LoveProclamation", (object) loveProclamation),
          new SqlParameter("@isExist", (object) isExist),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[3].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Update_Marry_Apply", SqlParameters);
                flag = (int)SqlParameters[3].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(UpdatePlayerMarryApply), ex);
            }
            return flag;
        }

        public MarryApplyInfo[] GetPlayerMarryApply(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            List<MarryApplyInfo> marryApplyInfoList = new List<MarryApplyInfo>();
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", (object) UserID)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Get_Marry_Apply", SqlParameters);
                while (ResultDataReader.Read())
                    marryApplyInfoList.Add(new MarryApplyInfo()
                    {
                        UserID = (int)ResultDataReader[nameof(UserID)],
                        ApplyUserID = (int)ResultDataReader["ApplyUserID"],
                        ApplyUserName = ResultDataReader["ApplyUserName"].ToString(),
                        ApplyType = (int)ResultDataReader["ApplyType"],
                        ApplyResult = (bool)ResultDataReader["ApplyResult"],
                        LoveProclamation = ResultDataReader["LoveProclamation"].ToString(),
                        ID = (int)ResultDataReader["Id"]
                    });
                return marryApplyInfoList.ToArray();
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetPlayerMarryApply), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (MarryApplyInfo[])null;
        }

        public bool InsertMarryRoomInfo(MarryRoomInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[20];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.InputOutput;
                SqlParameters[1] = new SqlParameter("@Name", (object)info.Name);
                SqlParameters[2] = new SqlParameter("@PlayerID", (object)info.PlayerID);
                SqlParameters[3] = new SqlParameter("@PlayerName", (object)info.PlayerName);
                SqlParameters[4] = new SqlParameter("@GroomID", (object)info.GroomID);
                SqlParameters[5] = new SqlParameter("@GroomName", (object)info.GroomName);
                SqlParameters[6] = new SqlParameter("@BrideID", (object)info.BrideID);
                SqlParameters[7] = new SqlParameter("@BrideName", (object)info.BrideName);
                SqlParameters[8] = new SqlParameter("@Pwd", (object)info.Pwd);
                SqlParameters[9] = new SqlParameter("@AvailTime", (object)info.AvailTime);
                SqlParameters[10] = new SqlParameter("@MaxCount", (object)info.MaxCount);
                SqlParameters[11] = new SqlParameter("@GuestInvite", (object)info.GuestInvite);
                SqlParameters[12] = new SqlParameter("@MapIndex", (object)info.MapIndex);
                SqlParameters[13] = new SqlParameter("@BeginTime", (object)info.BeginTime);
                SqlParameters[14] = new SqlParameter("@BreakTime", (object)info.BreakTime);
                SqlParameters[15] = new SqlParameter("@RoomIntroduction", (object)info.RoomIntroduction);
                SqlParameters[16] = new SqlParameter("@ServerID", (object)info.ServerID);
                SqlParameters[17] = new SqlParameter("@IsHymeneal", (object)info.IsHymeneal);
                SqlParameters[18] = new SqlParameter("@IsGunsaluteUsed", (object)info.IsGunsaluteUsed);
                SqlParameters[19] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[19].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Insert_Marry_Room_Info", SqlParameters);
                if (flag = (int)SqlParameters[19].Value == 0)
                    info.ID = (int)SqlParameters[0].Value;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(InsertMarryRoomInfo), ex);
            }
            return flag;
        }

        public bool UpdateMarryRoomInfo(MarryRoomInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[9]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@AvailTime", (object) info.AvailTime),
          new SqlParameter("@BreakTime", (object) info.BreakTime),
          new SqlParameter("@roomIntroduction", (object) info.RoomIntroduction),
          new SqlParameter("@isHymeneal", (object) info.IsHymeneal),
          new SqlParameter("@Name", (object) info.Name),
          new SqlParameter("@Pwd", (object) info.Pwd),
          new SqlParameter("@IsGunsaluteUsed", (object) info.IsGunsaluteUsed),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[8].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Update_Marry_Room_Info", SqlParameters);
                flag = (int)SqlParameters[8].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(UpdateMarryRoomInfo), ex);
            }
            return flag;
        }

        public bool DisposeMarryRoomInfo(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
          new SqlParameter("@ID", (object) ID),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[1].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Dispose_Marry_Room_Info", SqlParameters);
                flag = (int)SqlParameters[1].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(DisposeMarryRoomInfo), ex);
            }
            return flag;
        }

        public MarryRoomInfo[] GetMarryRoomInfo()
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            List<MarryRoomInfo> marryRoomInfoList = new List<MarryRoomInfo>();
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Get_Marry_Room_Info");
                while (ResultDataReader.Read())
                    marryRoomInfoList.Add(new MarryRoomInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        Name = ResultDataReader["Name"].ToString(),
                        PlayerID = (int)ResultDataReader["PlayerID"],
                        PlayerName = ResultDataReader["PlayerName"].ToString(),
                        GroomID = (int)ResultDataReader["GroomID"],
                        GroomName = ResultDataReader["GroomName"].ToString(),
                        BrideID = (int)ResultDataReader["BrideID"],
                        BrideName = ResultDataReader["BrideName"].ToString(),
                        Pwd = ResultDataReader["Pwd"].ToString(),
                        AvailTime = (int)ResultDataReader["AvailTime"],
                        MaxCount = (int)ResultDataReader["MaxCount"],
                        GuestInvite = (bool)ResultDataReader["GuestInvite"],
                        MapIndex = (int)ResultDataReader["MapIndex"],
                        BeginTime = (DateTime)ResultDataReader["BeginTime"],
                        BreakTime = (DateTime)ResultDataReader["BreakTime"],
                        RoomIntroduction = ResultDataReader["RoomIntroduction"].ToString(),
                        ServerID = (int)ResultDataReader["ServerID"],
                        IsHymeneal = (bool)ResultDataReader["IsHymeneal"],
                        IsGunsaluteUsed = (bool)ResultDataReader["IsGunsaluteUsed"]
                    });
                return marryRoomInfoList.ToArray();
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetMarryRoomInfo), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (MarryRoomInfo[])null;
        }

        public MarryRoomInfo GetMarryRoomInfoSingle(int id)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ID", (object) id)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Get_Marry_Room_Info_Single", SqlParameters);
                if (ResultDataReader.Read())
                    return new MarryRoomInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        Name = ResultDataReader["Name"].ToString(),
                        PlayerID = (int)ResultDataReader["PlayerID"],
                        PlayerName = ResultDataReader["PlayerName"].ToString(),
                        GroomID = (int)ResultDataReader["GroomID"],
                        GroomName = ResultDataReader["GroomName"].ToString(),
                        BrideID = (int)ResultDataReader["BrideID"],
                        BrideName = ResultDataReader["BrideName"].ToString(),
                        Pwd = ResultDataReader["Pwd"].ToString(),
                        AvailTime = (int)ResultDataReader["AvailTime"],
                        MaxCount = (int)ResultDataReader["MaxCount"],
                        GuestInvite = (bool)ResultDataReader["GuestInvite"],
                        MapIndex = (int)ResultDataReader["MapIndex"],
                        BeginTime = (DateTime)ResultDataReader["BeginTime"],
                        BreakTime = (DateTime)ResultDataReader["BreakTime"],
                        RoomIntroduction = ResultDataReader["RoomIntroduction"].ToString(),
                        ServerID = (int)ResultDataReader["ServerID"],
                        IsHymeneal = (bool)ResultDataReader["IsHymeneal"],
                        IsGunsaluteUsed = (bool)ResultDataReader["IsGunsaluteUsed"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetMarryRoomInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (MarryRoomInfo)null;
        }

        public bool UpdateBreakTimeWhereServerStop()
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[0].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Update_Marry_Room_Info_Sever_Stop", SqlParameters);
                flag = (int)SqlParameters[0].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(UpdateBreakTimeWhereServerStop), ex);
            }
            return flag;
        }

        public MarryProp GetMarryProp(int id)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", (object) id)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Select_Marry_Prop", SqlParameters);
                if (ResultDataReader.Read())
                    return new MarryProp()
                    {
                        IsMarried = (bool)ResultDataReader["IsMarried"],
                        SpouseID = (int)ResultDataReader["SpouseID"],
                        SpouseName = ResultDataReader["SpouseName"].ToString(),
                        IsCreatedMarryRoom = (bool)ResultDataReader["IsCreatedMarryRoom"],
                        SelfMarryRoomID = (int)ResultDataReader["SelfMarryRoomID"],
                        IsGotRing = (bool)ResultDataReader["IsGotRing"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetMarryProp), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (MarryProp)null;
        }

        public bool SavePlayerMarryNotice(MarryApplyInfo info, int answerId, ref int id)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[9]
                {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@ApplyUserID", (object) info.ApplyUserID),
          new SqlParameter("@ApplyUserName", (object) info.ApplyUserName),
          new SqlParameter("@ApplyType", (object) info.ApplyType),
          new SqlParameter("@ApplyResult", (object) info.ApplyResult),
          new SqlParameter("@LoveProclamation", (object) info.LoveProclamation),
          new SqlParameter("@AnswerId", (object) answerId),
          new SqlParameter("@ouototal", SqlDbType.Int),
          null
                };
                SqlParameters[7].Direction = ParameterDirection.Output;
                SqlParameters[8] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[8].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Insert_Marry_Notice", SqlParameters);
                id = (int)SqlParameters[7].Value;
                flag = (int)SqlParameters[8].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(SavePlayerMarryNotice), ex);
            }
            return flag;
        }

        public bool UpdatePlayerGotRingProp(int groomID, int brideID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[3]
                {
          new SqlParameter("@GroomID", (object) groomID),
          new SqlParameter("@BrideID", (object) brideID),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[2].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Update_GotRing_Prop", SqlParameters);
                flag = (int)SqlParameters[2].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(UpdatePlayerGotRingProp), ex);
            }
            return flag;
        }

        public HotSpringRoomInfo[] GetHotSpringRoomInfo()
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            List<HotSpringRoomInfo> hotSpringRoomInfoList = new List<HotSpringRoomInfo>();
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Get_HotSpring_Room");
                while (ResultDataReader.Read())
                {
                    HotSpringRoomInfo hotSpringRoomInfo = new HotSpringRoomInfo()
                    {
                        RoomID = (int)ResultDataReader["RoomID"],
                        RoomName = ResultDataReader["RoomName"] == null ? "" : ResultDataReader["RoomName"].ToString(),
                        PlayerID = (int)ResultDataReader["PlayerID"],
                        PlayerName = ResultDataReader["PlayerName"] == null ? "" : ResultDataReader["PlayerName"].ToString(),
                        Pwd = ResultDataReader["Pwd"].ToString() == null ? "" : ResultDataReader["Pwd"].ToString(),
                        AvailTime = (int)ResultDataReader["AvailTime"],
                        MaxCount = (int)ResultDataReader["MaxCount"],
                        BeginTime = (DateTime)ResultDataReader["BeginTime"],
                        BreakTime = (DateTime)ResultDataReader["BreakTime"],
                        RoomIntroduction = ResultDataReader["RoomIntroduction"] == null ? "" : ResultDataReader["RoomIntroduction"].ToString(),
                        RoomType = (int)ResultDataReader["RoomType"],
                        ServerID = (int)ResultDataReader["ServerID"],
                        RoomNumber = (int)ResultDataReader["RoomNumber"]
                    };
                    hotSpringRoomInfoList.Add(hotSpringRoomInfo);
                }
                return hotSpringRoomInfoList.ToArray();
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"HotSpringRoomInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (HotSpringRoomInfo[])null;
        }

        public HotSpringRoomInfo GetHotSpringRoomInfoSingle(int id)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@RoomID", (object) id)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Get_HotSpringRoomInfo_Single", SqlParameters);
                if (ResultDataReader.Read())
                    return new HotSpringRoomInfo()
                    {
                        RoomID = (int)ResultDataReader["RoomID"],
                        RoomName = ResultDataReader["RoomName"].ToString(),
                        PlayerID = (int)ResultDataReader["PlayerID"],
                        PlayerName = ResultDataReader["PlayerName"].ToString(),
                        Pwd = ResultDataReader["Pwd"].ToString(),
                        AvailTime = (int)ResultDataReader["AvailTime"],
                        MaxCount = (int)ResultDataReader["MaxCount"],
                        MapIndex = (int)ResultDataReader["MapIndex"],
                        BeginTime = (DateTime)ResultDataReader["BeginTime"],
                        BreakTime = (DateTime)ResultDataReader["BreakTime"],
                        RoomIntroduction = ResultDataReader["RoomIntroduction"].ToString(),
                        RoomType = (int)ResultDataReader["RoomType"],
                        ServerID = (int)ResultDataReader["ServerID"],
                        RoomNumber = (int)ResultDataReader["RoomNumber"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"HotSpringRoomInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (HotSpringRoomInfo)null;
        }

        public bool UpdateHotSpringRoomInfo(HotSpringRoomInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[7]
                {
          new SqlParameter("@RoomID", (object) info.RoomID),
          new SqlParameter("@RoomName", (object) info.RoomName),
          new SqlParameter("@Pwd", (object) info.Pwd),
          new SqlParameter("@AvailTime", (object) info.AvailTime.ToString()),
          new SqlParameter("@BreakTime", (object) info.BreakTime.ToString()),
          new SqlParameter("@roomIntroduction", (object) info.RoomIntroduction),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[6].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Update_HotSpringRoomInfo", SqlParameters);
                flag = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(UpdateHotSpringRoomInfo), ex);
            }
            return flag;
        }

        public bool UpdateLastVIPPackTime(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[3]
                {
          new SqlParameter("@UserID", (object) ID),
          new SqlParameter("@LastVIPPackTime", (object) DateTime.Now.Date),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[2].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UpdateUserLastVIPPackTime", SqlParameters);
                flag = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateUserLastVIPPackTime", ex);
            }
            return flag;
        }

        public bool UpdateVIPInfo(PlayerInfo p)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[10]
                {
          new SqlParameter("@ID", (object) p.ID),
          new SqlParameter("@VIPLevel", (object) p.VIPLevel),
          new SqlParameter("@VIPExp", (object) p.VIPExp),
          new SqlParameter("@VIPOnlineDays", SqlDbType.BigInt),
          new SqlParameter("@VIPOfflineDays", SqlDbType.BigInt),
          new SqlParameter("@VIPExpireDay", (object) p.VIPExpireDay.ToString()),
          new SqlParameter("@VIPLastDate", (object) DateTime.Now),
          new SqlParameter("@VIPNextLevelDaysNeeded", SqlDbType.BigInt),
          new SqlParameter("@CanTakeVipReward", (object) p.CanTakeVipReward),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[9].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UpdateVIPInfo", SqlParameters);
                flag = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateVIPInfo", ex);
            }
            return flag;
        }

        public int method_0(string nickName, int renewalDays, ref DateTime ExpireDayOut)
        {
            int num = 0;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[4]
                {
          new SqlParameter("@NickName", (object) nickName),
          new SqlParameter("@RenewalDays", (object) renewalDays),
          new SqlParameter("@ExpireDayOut", (object) DateTime.Now),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[2].Direction = ParameterDirection.Output;
                SqlParameters[3].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_VIPRenewal_Single", SqlParameters);
                ExpireDayOut = (DateTime)SqlParameters[2].Value;
                num = (int)SqlParameters[3].Value;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_VIPRenewal_Single", ex);
            }
            return num;
        }

        public bool Test(string DutyName)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Test1", new SqlParameter[1]
                {
          new SqlParameter("@DutyName", (object) DutyName)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool TankAll()
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Tank_All", new SqlParameter[0]);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool RegisterUser(
          string UserName,
          string NickName,
          string Password,
          bool Sex,
          int Money,
          int GiftToken,
          int Gold)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[8]
                {
          new SqlParameter("@UserName", (object) UserName),
          new SqlParameter("@Password", (object) Password),
          new SqlParameter("@NickName", (object) NickName),
          new SqlParameter("@Sex", (object) Sex),
          new SqlParameter("@Money", (object) Money),
          new SqlParameter("@GiftToken", (object) GiftToken),
          new SqlParameter("@Gold", (object) Gold),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[7].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Account_Register", SqlParameters);
                if ((int)SqlParameters[7].Value == 0)
                    flag = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init Register", ex);
            }
            return flag;
        }

        public bool CheckEmailIsValid(string Email)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
          new SqlParameter("@Email", (object) Email),
          new SqlParameter("@count", SqlDbType.BigInt)
                };
                SqlParameters[1].Direction = ParameterDirection.Output;
                this.db.RunProcedure(nameof(CheckEmailIsValid), SqlParameters);
                if (int.Parse(SqlParameters[1].Value.ToString()) == 0)
                    flag = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init CheckEmailIsValid", ex);
            }
            return flag;
        }

        public bool RegisterUserInfo(UserInfo userinfo)
        {
            bool flag = false;
            try
            {
                return this.db.RunProcedure("SP_User_Info_Add", new SqlParameter[6]
                {
          new SqlParameter("@UserID", (object) userinfo.UserID),
          new SqlParameter("@UserEmail", (object) userinfo.UserEmail),
          new SqlParameter("@UserPhone", userinfo.UserPhone == null ? (object) string.Empty : (object) userinfo.UserPhone),
          new SqlParameter("@UserOther1", userinfo.UserOther1 == null ? (object) string.Empty : (object) userinfo.UserOther1),
          new SqlParameter("@UserOther2", userinfo.UserOther2 == null ? (object) string.Empty : (object) userinfo.UserOther2),
          new SqlParameter("@UserOther3", userinfo.UserOther3 == null ? (object) string.Empty : (object) userinfo.UserOther3)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public UserInfo GetUserInfo(int UserId)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            UserInfo userInfo = new UserInfo() { UserID = UserId };
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", (object) UserId)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Get_User_Info", SqlParameters);
                while (ResultDataReader.Read())
                {
                    userInfo.UserID = int.Parse(ResultDataReader["UserID"].ToString());
                    userInfo.UserEmail = ResultDataReader["UserEmail"] == null ? "" : ResultDataReader["UserEmail"].ToString();
                    userInfo.UserPhone = ResultDataReader["UserPhone"] == null ? "" : ResultDataReader["UserPhone"].ToString();
                    userInfo.UserOther1 = ResultDataReader["UserOther1"] == null ? "" : ResultDataReader["UserOther1"].ToString();
                    userInfo.UserOther2 = ResultDataReader["UserOther2"] == null ? "" : ResultDataReader["UserOther2"].ToString();
                    userInfo.UserOther3 = ResultDataReader["UserOther3"] == null ? "" : ResultDataReader["UserOther3"].ToString();
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return userInfo;
        }

        public LevelInfo[] GetAllLevel()
        {
            List<LevelInfo> levelInfoList = new List<LevelInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Level_All");
                while (ResultDataReader.Read())
                    levelInfoList.Add(new LevelInfo()
                    {
                        Grade = (int)ResultDataReader["Grade"],
                        GP = (int)ResultDataReader["GP"],
                        Blood = (int)ResultDataReader["Blood"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetAllLevel), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return levelInfoList.ToArray();
        }

        public FairBattleRewardInfo[] GetAllFairBattleReward()
        {
            List<FairBattleRewardInfo> battleRewardInfoList = new List<FairBattleRewardInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_FairBattleReward_All");
                while (ResultDataReader.Read())
                    battleRewardInfoList.Add(new FairBattleRewardInfo()
                    {
                        Prestige = (int)ResultDataReader["Prestige"],
                        Level = (int)ResultDataReader["Level"],
                        Name = (string)ResultDataReader["Name"],
                        PrestigeForWin = (int)ResultDataReader["PrestigeForWin"],
                        PrestigeForLose = (int)ResultDataReader["PrestigeForLose"],
                        Title = (string)ResultDataReader["Title"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetAllFairBattleReward), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return battleRewardInfoList.ToArray();
        }

        public ExerciseInfo[] GetAllExercise()
        {
            List<ExerciseInfo> exerciseInfoList = new List<ExerciseInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Exercise_All");
                while (ResultDataReader.Read())
                    exerciseInfoList.Add(new ExerciseInfo()
                    {
                        Grage = (int)ResultDataReader["Grage"],
                        GP = (int)ResultDataReader["GP"],
                        ExerciseA = (int)ResultDataReader["ExerciseA"],
                        ExerciseAG = (int)ResultDataReader["ExerciseAG"],
                        ExerciseD = (int)ResultDataReader["ExerciseD"],
                        ExerciseH = (int)ResultDataReader["ExerciseH"],
                        ExerciseL = (int)ResultDataReader["ExerciseL"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetAllExercise), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return exerciseInfoList.ToArray();
        }

        public LevelInfo GetUserLevelSingle(int Grade)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@Grade", (object) Grade)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Get_Level_By_Grade", SqlParameters);
                if (ResultDataReader.Read())
                    return new LevelInfo()
                    {
                        Grade = (int)ResultDataReader[nameof(Grade)],
                        GP = (int)ResultDataReader["GP"],
                        Blood = (int)ResultDataReader["Blood"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetLevelInfoSingle", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (LevelInfo)null;
        }

        public ExerciseInfo GetExerciseSingle(int Grade)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@Grage", (object) Grade)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Get_Exercise_By_Grade", SqlParameters);
                if (ResultDataReader.Read())
                    return new ExerciseInfo()
                    {
                        Grage = (int)ResultDataReader["Grage"],
                        GP = (int)ResultDataReader["GP"],
                        ExerciseA = (int)ResultDataReader["ExerciseA"],
                        ExerciseAG = (int)ResultDataReader["ExerciseAG"],
                        ExerciseD = (int)ResultDataReader["ExerciseD"],
                        ExerciseH = (int)ResultDataReader["ExerciseH"],
                        ExerciseL = (int)ResultDataReader["ExerciseL"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetExerciseInfoSingle", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (ExerciseInfo)null;
        }

        public TexpInfo GetUserTexpInfoSingle(int ID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", (object) ID)
                };
                this.db.GetReader(ref ResultDataReader, "SP_Get_UserTexp_By_ID", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitTexpInfo(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetTexpInfoSingle", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (TexpInfo)null;
        }

        public bool UpdateUserTexpInfo(TexpInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[10]
                {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@attTexpExp", (object) info.attTexpExp),
          new SqlParameter("@defTexpExp", (object) info.defTexpExp),
          new SqlParameter("@hpTexpExp", (object) info.hpTexpExp),
          new SqlParameter("@lukTexpExp", (object) info.lukTexpExp),
          new SqlParameter("@spdTexpExp", (object) info.spdTexpExp),
          new SqlParameter("@texpCount", (object) info.texpCount),
          new SqlParameter("@texpTaskCount", (object) info.texpTaskCount),
          new SqlParameter("@texpTaskDate", (object) info.texpTaskDate.ToString()),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[9].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UserTexp_Update", SqlParameters);
                flag = (int)SqlParameters[9].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool InsertUserTexpInfo(TexpInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[10]
                {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@attTexpExp", (object) info.attTexpExp),
          new SqlParameter("@defTexpExp", (object) info.defTexpExp),
          new SqlParameter("@hpTexpExp", (object) info.hpTexpExp),
          new SqlParameter("@lukTexpExp", (object) info.lukTexpExp),
          new SqlParameter("@spdTexpExp", (object) info.spdTexpExp),
          new SqlParameter("@texpCount", (object) info.texpCount),
          new SqlParameter("@texpTaskCount", (object) info.texpTaskCount),
          new SqlParameter("@texpTaskDate", (object) info.texpTaskDate.ToString()),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[9].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UserTexp_Add", SqlParameters);
                flag = (int)SqlParameters[9].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InsertTexpInfo", ex);
            }
            return flag;
        }

        public bool AddeqPet(PetEquipDataInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[9];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)info.UserID);
                SqlParameters[2] = new SqlParameter("@PetID", (object)info.PetID);
                SqlParameters[3] = new SqlParameter("@eqType", (object)info.eqType);
                SqlParameters[4] = new SqlParameter("@eqTemplateID", (object)info.eqTemplateID);
                SqlParameters[5] = new SqlParameter("@startTime", (object)info.startTime);
                SqlParameters[6] = new SqlParameter("@ValidDate", (object)info.ValidDate);
                SqlParameters[7] = new SqlParameter("@IsExit", (object)info.IsExit);
                SqlParameters[8] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[8].Direction = ParameterDirection.ReturnValue;
                flag = this.db.RunProcedure("SP_User_Add_eqPet", SqlParameters);
                flag = (int)SqlParameters[8].Value == 0;
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateqPet(PetEquipDataInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[9]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@PetID", (object) info.PetID),
          new SqlParameter("@eqType", (object) info.eqType),
          new SqlParameter("@eqTemplateID", (object) info.eqTemplateID),
          new SqlParameter("@startTime", (object) info.startTime),
          new SqlParameter("@ValidDate", (object) info.ValidDate),
          new SqlParameter("@IsExit", (object) info.IsExit),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[8].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_eqPet_Update", SqlParameters);
                flag = (int)SqlParameters[8].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool AddUserPet(UsersPetinfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[31]
                {
          new SqlParameter("@TemplateID", (object) info.TemplateID),
          new SqlParameter("@Name", info.Name == null ? (object) "Error!" : (object) info.Name),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@Attack", (object) info.Attack),
          new SqlParameter("@Defence", (object) info.Defence),
          new SqlParameter("@Luck", (object) info.Luck),
          new SqlParameter("@Agility", (object) info.Agility),
          new SqlParameter("@Blood", (object) info.Blood),
          new SqlParameter("@Damage", (object) info.Damage),
          new SqlParameter("@Guard", (object) info.Guard),
          new SqlParameter("@AttackGrow", (object) info.AttackGrow),
          new SqlParameter("@DefenceGrow", (object) info.DefenceGrow),
          new SqlParameter("@LuckGrow", (object) info.LuckGrow),
          new SqlParameter("@AgilityGrow", (object) info.AgilityGrow),
          new SqlParameter("@BloodGrow", (object) info.BloodGrow),
          new SqlParameter("@DamageGrow", (object) info.DamageGrow),
          new SqlParameter("@GuardGrow", (object) info.GuardGrow),
          new SqlParameter("@Level", (object) info.Level),
          new SqlParameter("@GP", (object) info.GP),
          new SqlParameter("@MaxGP", (object) info.MaxGP),
          new SqlParameter("@Hunger", (object) info.Hunger),
          new SqlParameter("@PetHappyStar", (object) info.PetHappyStar),
          new SqlParameter("@MP", (object) info.MP),
          new SqlParameter("@IsEquip", (object) info.IsEquip),
          new SqlParameter("@Skill", (object) info.Skill),
          new SqlParameter("@SkillEquip", (object) info.SkillEquip),
          new SqlParameter("@Place", (object) info.Place),
          new SqlParameter("@IsExit", (object) info.IsExit),
          new SqlParameter("@ID", (object) info.ID),
          null,
          null
                };
                SqlParameters[28].Direction = ParameterDirection.Output;
                SqlParameters[29] = new SqlParameter("@currentStarExp", (object)info.currentStarExp);
                SqlParameters[30] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[30].Direction = ParameterDirection.ReturnValue;
                flag = this.db.RunProcedure("SP_User_Add_Pet", SqlParameters);
                flag = (int)SqlParameters[30].Value == 0;
                info.ID = (int)SqlParameters[28].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateUserPet(UsersPetinfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[31]
                {
          new SqlParameter("@TemplateID", (object) info.TemplateID),
          new SqlParameter("@Name", info.Name == null ? (object) "Error!" : (object) info.Name),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@Attack", (object) info.Attack),
          new SqlParameter("@Defence", (object) info.Defence),
          new SqlParameter("@Luck", (object) info.Luck),
          new SqlParameter("@Agility", (object) info.Agility),
          new SqlParameter("@Blood", (object) info.Blood),
          new SqlParameter("@Damage", (object) info.Damage),
          new SqlParameter("@Guard", (object) info.Guard),
          new SqlParameter("@AttackGrow", (object) info.AttackGrow),
          new SqlParameter("@DefenceGrow", (object) info.DefenceGrow),
          new SqlParameter("@LuckGrow", (object) info.LuckGrow),
          new SqlParameter("@AgilityGrow", (object) info.AgilityGrow),
          new SqlParameter("@BloodGrow", (object) info.BloodGrow),
          new SqlParameter("@DamageGrow", (object) info.DamageGrow),
          new SqlParameter("@GuardGrow", (object) info.GuardGrow),
          new SqlParameter("@Level", (object) info.Level),
          new SqlParameter("@GP", (object) info.GP),
          new SqlParameter("@MaxGP", (object) info.MaxGP),
          new SqlParameter("@Hunger", (object) info.Hunger),
          new SqlParameter("@PetHappyStar", (object) info.PetHappyStar),
          new SqlParameter("@MP", (object) info.MP),
          new SqlParameter("@IsEquip", (object) info.IsEquip),
          new SqlParameter("@Place", (object) info.Place),
          new SqlParameter("@IsExit", (object) info.IsExit),
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@Skill", (object) info.Skill),
          new SqlParameter("@SkillEquip", (object) info.SkillEquip),
          new SqlParameter("@currentStarExp", (object) info.currentStarExp),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[30].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UserPet_Update", SqlParameters);
                flag = (int)SqlParameters[30].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public UsersPetinfo GetAdoptPetSingle(int PetID)
        {
            UsersPetinfo usersPetinfo = new UsersPetinfo();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)PetID;
                this.db.GetReader(ref ResultDataReader, "SP_AdoptPet_By_Id", SqlParameters);
                if (ResultDataReader.Read())
                    return new UsersPetinfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        TemplateID = (int)ResultDataReader["TemplateID"],
                        Name = ResultDataReader["Name"].ToString(),
                        UserID = (int)ResultDataReader["UserID"],
                        Attack = (int)ResultDataReader["Attack"],
                        AttackGrow = (int)ResultDataReader["AttackGrow"],
                        Agility = (int)ResultDataReader["Agility"],
                        AgilityGrow = (int)ResultDataReader["AgilityGrow"],
                        Defence = (int)ResultDataReader["Defence"],
                        DefenceGrow = (int)ResultDataReader["DefenceGrow"],
                        Luck = (int)ResultDataReader["Luck"],
                        LuckGrow = (int)ResultDataReader["LuckGrow"],
                        Blood = (int)ResultDataReader["Blood"],
                        BloodGrow = (int)ResultDataReader["BloodGrow"],
                        Damage = (int)ResultDataReader["Damage"],
                        DamageGrow = (int)ResultDataReader["DamageGrow"],
                        Guard = (int)ResultDataReader["Guard"],
                        GuardGrow = (int)ResultDataReader["GuardGrow"],
                        Level = (int)ResultDataReader["Level"],
                        GP = (int)ResultDataReader["GP"],
                        MaxGP = (int)ResultDataReader["MaxGP"],
                        Hunger = (int)ResultDataReader["Hunger"],
                        MP = (int)ResultDataReader["MP"],
                        Place = (int)ResultDataReader["Place"],
                        IsEquip = (bool)ResultDataReader["IsEquip"],
                        IsExit = (bool)ResultDataReader["IsExit"],
                        Skill = ResultDataReader["Skill"].ToString(),
                        SkillEquip = ResultDataReader["SkillEquip"].ToString()
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (UsersPetinfo)null;
        }

        public UsersPetinfo[] GetUserAdoptPetSingles(int UserID)
        {
            List<UsersPetinfo> usersPetinfoList = new List<UsersPetinfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Get_User_AdoptPetList", SqlParameters);
                while (ResultDataReader.Read())
                    usersPetinfoList.Add(new UsersPetinfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        TemplateID = (int)ResultDataReader["TemplateID"],
                        Name = ResultDataReader["Name"].ToString(),
                        UserID = (int)ResultDataReader[nameof(UserID)],
                        Attack = (int)ResultDataReader["Attack"],
                        AttackGrow = (int)ResultDataReader["AttackGrow"],
                        Agility = (int)ResultDataReader["Agility"],
                        AgilityGrow = (int)ResultDataReader["AgilityGrow"],
                        Defence = (int)ResultDataReader["Defence"],
                        DefenceGrow = (int)ResultDataReader["DefenceGrow"],
                        Luck = (int)ResultDataReader["Luck"],
                        LuckGrow = (int)ResultDataReader["LuckGrow"],
                        Blood = (int)ResultDataReader["Blood"],
                        BloodGrow = (int)ResultDataReader["BloodGrow"],
                        Damage = (int)ResultDataReader["Damage"],
                        DamageGrow = (int)ResultDataReader["DamageGrow"],
                        Guard = (int)ResultDataReader["Guard"],
                        GuardGrow = (int)ResultDataReader["GuardGrow"],
                        Level = (int)ResultDataReader["Level"],
                        GP = (int)ResultDataReader["GP"],
                        MaxGP = (int)ResultDataReader["MaxGP"],
                        Hunger = (int)ResultDataReader["Hunger"],
                        MP = (int)ResultDataReader["MP"],
                        Place = (int)ResultDataReader["Place"],
                        IsEquip = (bool)ResultDataReader["IsEquip"],
                        IsExit = (bool)ResultDataReader["IsExit"],
                        Skill = ResultDataReader["Skill"].ToString(),
                        SkillEquip = ResultDataReader["SkillEquip"].ToString()
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return usersPetinfoList.ToArray();
        }

        public bool RemoveUserAdoptPet(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
          new SqlParameter("@ID", (object) ID),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[1].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Remove_User_AdoptPet", SqlParameters);
                flag = (int)SqlParameters[1].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool ClearAdoptPet(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
          new SqlParameter("@ID", (object) ID),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[1].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Clear_AdoptPet", SqlParameters);
                flag = (int)SqlParameters[1].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool ClearDatabase()
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Sys_Clear_All");
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateUserAdoptPet(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
          new SqlParameter("@ID", (object) ID),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[1].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Update_User_AdoptPet", SqlParameters);
                flag = (int)SqlParameters[1].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool AddUserAdoptPet(UsersPetinfo info, bool isUse)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[23]
                {
          new SqlParameter("@TemplateID", (object) info.TemplateID),
          new SqlParameter("@Name", info.Name == null ? (object) "Error!" : (object) info.Name),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@Attack", (object) info.Attack),
          new SqlParameter("@Defence", (object) info.Defence),
          new SqlParameter("@Luck", (object) info.Luck),
          new SqlParameter("@Agility", (object) info.Agility),
          new SqlParameter("@Blood", (object) info.Blood),
          new SqlParameter("@Damage", (object) info.Damage),
          new SqlParameter("@Guard", (object) info.Guard),
          new SqlParameter("@AttackGrow", (object) info.AttackGrow),
          new SqlParameter("@DefenceGrow", (object) info.DefenceGrow),
          new SqlParameter("@LuckGrow", (object) info.LuckGrow),
          new SqlParameter("@AgilityGrow", (object) info.AgilityGrow),
          new SqlParameter("@BloodGrow", (object) info.BloodGrow),
          new SqlParameter("@DamageGrow", (object) info.DamageGrow),
          new SqlParameter("@GuardGrow", (object) info.GuardGrow),
          new SqlParameter("@Skill", (object) info.Skill),
          new SqlParameter("@SkillEquip", (object) info.SkillEquip),
          new SqlParameter("@Place", (object) info.Place),
          new SqlParameter("@IsExit", (object) info.IsExit),
          new SqlParameter("@IsUse", (object) isUse),
          new SqlParameter("@ID", (object) info.ID)
                };
                SqlParameters[22].Direction = ParameterDirection.Output;
                flag = this.db.RunProcedure("SP_User_AdoptPet", SqlParameters);
                info.ID = (int)SqlParameters[22].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public UsersPetinfo[] GetUserPetSingles(int UserID)
        {
            List<UsersPetinfo> usersPetinfoList = new List<UsersPetinfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Get_UserPet_By_ID", SqlParameters);
                while (ResultDataReader.Read())
                    usersPetinfoList.Add(this.InitPet(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return usersPetinfoList.ToArray();
        }

        public List<UsersPetinfo> GetUserPetIsExitSingles(int UserID)
        {
            List<UsersPetinfo> petIsExitSingles = new List<UsersPetinfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Get_UserPet_By_IsExit", SqlParameters);
                while (ResultDataReader.Read())
                    petIsExitSingles.Add(this.InitPet(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return petIsExitSingles;
        }

        public UsersPetinfo GetUserPetSingle(int ID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)ID;
                this.db.GetReader(ref ResultDataReader, "SP_Get_UserPet_By_ID", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitPet(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetPetInfoSingle", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (UsersPetinfo)null;
        }

        public PetConfig[] GetAllPetConfig()
        {
            List<PetConfig> petConfigList = new List<PetConfig>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_PetConfig_All");
                while (ResultDataReader.Read())
                    petConfigList.Add(new PetConfig()
                    {
                        ID = (int)ResultDataReader["ID"],
                        Name = ResultDataReader["Name"].ToString(),
                        Value = ResultDataReader["Value"].ToString()
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetAllPetConfig), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return petConfigList.ToArray();
        }

        public PetLevel[] GetAllPetLevel()
        {
            List<PetLevel> petLevelList = new List<PetLevel>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_PetLevel_All");
                while (ResultDataReader.Read())
                    petLevelList.Add(new PetLevel()
                    {
                        Level = (int)ResultDataReader["Level"],
                        GP = (int)ResultDataReader["GP"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetAllPetLevel), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return petLevelList.ToArray();
        }

        public PetTemplateInfo[] GetAllPetTemplateInfo()
        {
            List<PetTemplateInfo> petTemplateInfoList = new List<PetTemplateInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_PetTemplateInfo_All");
                while (ResultDataReader.Read())
                    petTemplateInfoList.Add(new PetTemplateInfo()
                    {
                        TemplateID = (int)ResultDataReader["TemplateID"],
                        Name = (string)ResultDataReader["Name"],
                        KindID = (int)ResultDataReader["KindID"],
                        Description = (string)ResultDataReader["Description"],
                        Pic = (string)ResultDataReader["Pic"],
                        RareLevel = (int)ResultDataReader["RareLevel"],
                        MP = (int)ResultDataReader["MP"],
                        StarLevel = (int)ResultDataReader["StarLevel"],
                        GameAssetUrl = (string)ResultDataReader["GameAssetUrl"],
                        HighAgility = (int)ResultDataReader["HighAgility"],
                        HighAgilityGrow = (int)ResultDataReader["HighAgilityGrow"],
                        HighAttack = (int)ResultDataReader["HighAttack"],
                        HighAttackGrow = (int)ResultDataReader["HighAttackGrow"],
                        HighBlood = (int)ResultDataReader["HighBlood"],
                        HighBloodGrow = (int)ResultDataReader["HighBloodGrow"],
                        HighDamage = (int)ResultDataReader["HighDamage"],
                        HighDamageGrow = (int)ResultDataReader["HighDamageGrow"],
                        HighDefence = (int)ResultDataReader["HighDefence"],
                        HighDefenceGrow = (int)ResultDataReader["HighDefenceGrow"],
                        HighGuard = (int)ResultDataReader["HighGuard"],
                        HighGuardGrow = (int)ResultDataReader["HighGuardGrow"],
                        HighLuck = (int)ResultDataReader["HighLuck"],
                        HighLuckGrow = (int)ResultDataReader["HighLuckGrow"],
                        EvolutionID = (int)ResultDataReader["EvolutionID"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetAllPetTemplateInfo), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return petTemplateInfoList.ToArray();
        }

        public PetSkillTemplateInfo[] GetAllPetSkillTemplateInfo()
        {
            List<PetSkillTemplateInfo> skillTemplateInfoList = new List<PetSkillTemplateInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_PetSkillTemplateInfo_All");
                while (ResultDataReader.Read())
                    skillTemplateInfoList.Add(new PetSkillTemplateInfo()
                    {
                        PetTemplateID = (int)ResultDataReader["PetTemplateID"],
                        KindID = (int)ResultDataReader["KindID"],
                        Type = (int)ResultDataReader["GetType"],
                        SkillID = (int)ResultDataReader["SkillID"],
                        SkillBookID = (int)ResultDataReader["SkillBookID"],
                        MinLevel = (int)ResultDataReader["MinLevel"],
                        DeleteSkillIDs = ResultDataReader["DeleteSkillIDs"].ToString()
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetAllPetSkillTemplateInfo), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return skillTemplateInfoList.ToArray();
        }

        public PetSkillInfo[] GetAllPetSkillInfo()
        {
            List<PetSkillInfo> petSkillInfoList = new List<PetSkillInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_PetSkillInfo_All");
                while (ResultDataReader.Read())
                    petSkillInfoList.Add(new PetSkillInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        Name = ResultDataReader["Name"].ToString(),
                        String_0 = ResultDataReader["ElementIDs"].ToString(),
                        Description = ResultDataReader["Description"].ToString(),
                        BallType = (int)ResultDataReader["BallType"],
                        NewBallID = (int)ResultDataReader["NewBallID"],
                        CostMP = (int)ResultDataReader["CostMP"],
                        Pic = (int)ResultDataReader["Pic"],
                        Action = ResultDataReader["Action"].ToString(),
                        EffectPic = ResultDataReader["EffectPic"].ToString(),
                        Delay = (int)ResultDataReader["Delay"],
                        ColdDown = (int)ResultDataReader["ColdDown"],
                        GameType = (int)ResultDataReader["GameType"],
                        Probability = (int)ResultDataReader["Probability"],
                        Damage = (int)ResultDataReader["Damage"],
                        DamageCrit = (int)ResultDataReader["DamageCrit"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetAllPetSkillInfo), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return petSkillInfoList.ToArray();
        }

        public PetSkillElementInfo[] GetAllPetSkillElementInfo()
        {
            List<PetSkillElementInfo> skillElementInfoList = new List<PetSkillElementInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_PetSkillElementInfo_All");
                while (ResultDataReader.Read())
                    skillElementInfoList.Add(new PetSkillElementInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        Name = ResultDataReader["Name"].ToString(),
                        EffectPic = ResultDataReader["EffectPic"].ToString(),
                        Description = ResultDataReader["Description"].ToString(),
                        Pic = (int)ResultDataReader["Pic"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetAllPetSkillElementInfo), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return skillElementInfoList.ToArray();
        }

        public PetExpItemPriceInfo[] GetAllPetExpItemPrice()
        {
            List<PetExpItemPriceInfo> expItemPriceInfoList = new List<PetExpItemPriceInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_PetExpItemPriceInfo_All");
                while (ResultDataReader.Read())
                    expItemPriceInfoList.Add(new PetExpItemPriceInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        Count = (int)ResultDataReader["Count"],
                        Money = (int)ResultDataReader["Money"],
                        ItemCount = (int)ResultDataReader["ItemCount"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetAllPetTemplateInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return expItemPriceInfoList.ToArray();
        }

        public PetFightPropertyInfo[] GetAllPetFightProperty()
        {
            List<PetFightPropertyInfo> fightPropertyInfoList = new List<PetFightPropertyInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_PetFightProperty_All");
                while (ResultDataReader.Read())
                    fightPropertyInfoList.Add(new PetFightPropertyInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        Exp = (int)ResultDataReader["Exp"],
                        Attack = (int)ResultDataReader["Attack"],
                        Agility = (int)ResultDataReader["Agility"],
                        Defence = (int)ResultDataReader["Defence"],
                        Lucky = (int)ResultDataReader["Lucky"],
                        Blood = (int)ResultDataReader["Blood"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetAllPetFightProperty), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return fightPropertyInfoList.ToArray();
        }

        public PetStarExpInfo[] GetAllPetStarExp()
        {
            List<PetStarExpInfo> petStarExpInfoList = new List<PetStarExpInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_PetStarExp_All");
                while (ResultDataReader.Read())
                    petStarExpInfoList.Add(new PetStarExpInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        Exp = (int)ResultDataReader["Exp"],
                        OldID = (int)ResultDataReader["OldID"],
                        NewID = (int)ResultDataReader["NewID"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetAllPetStarExp), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return petStarExpInfoList.ToArray();
        }

        public bool AddMountDatas(MountDataInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[7];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)info.UserID);
                SqlParameters[2] = new SqlParameter("@curUseHorse", (object)info.curUseHorse);
                SqlParameters[3] = new SqlParameter("@curLevel", (object)info.curLevel);
                SqlParameters[4] = new SqlParameter("@curExp", (object)info.curExp);
                SqlParameters[5] = new SqlParameter("@curHasSkill", (object)info.curHasSkill);
                SqlParameters[6] = new SqlParameter("@horsePicCherish", (object)info.horsePicCherish);
                flag = this.db.RunProcedure("SP_MountData_Add", SqlParameters);
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateMountData(MountDataInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[8]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@curUseHorse", (object) info.curUseHorse),
          new SqlParameter("@curLevel", (object) info.curLevel),
          new SqlParameter("@curExp", (object) info.curExp),
          new SqlParameter("@curHasSkill", (object) info.curHasSkill),
          new SqlParameter("@horsePicCherish", (object) info.horsePicCherish),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[7].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_MountData_Update", SqlParameters);
                flag = (int)SqlParameters[7].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public MountDataInfo GetSingleMountData(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_MountData_Single", SqlParameters);
                if (ResultDataReader.Read())
                    return new MountDataInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        UserID = (int)ResultDataReader[nameof(UserID)],
                        curUseHorse = (int)ResultDataReader["curUseHorse"],
                        curLevel = (int)ResultDataReader["curLevel"],
                        curExp = (int)ResultDataReader["curExp"],
                        curHasSkill = ResultDataReader["curHasSkill"].ToString(),
                        horsePicCherish = ResultDataReader["horsePicCherish"].ToString()
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (MountDataInfo)null;
        }

        public bool AddCards(UsersCardInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[16];
                SqlParameters[0] = new SqlParameter("@CardID", (object)item.CardID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@CardType", (object)item.CardType);
                SqlParameters[2] = new SqlParameter("@UserID", (object)item.UserID);
                SqlParameters[3] = new SqlParameter("@Place", (object)item.Place);
                SqlParameters[4] = new SqlParameter("@TemplateID", (object)item.TemplateID);
                SqlParameters[5] = new SqlParameter("@isFirstGet", (object)false);
                SqlParameters[6] = new SqlParameter("@Attack", (object)item.Attack);
                SqlParameters[7] = new SqlParameter("@Defence", (object)item.Defence);
                SqlParameters[8] = new SqlParameter("@Luck", (object)item.Luck);
                SqlParameters[9] = new SqlParameter("@Agility", (object)item.Agility);
                SqlParameters[10] = new SqlParameter("@Damage", (object)item.Damage);
                SqlParameters[11] = new SqlParameter("@Guard", (object)item.Guard);
                SqlParameters[12] = new SqlParameter("@IsExit", (object)item.IsExit);
                SqlParameters[13] = new SqlParameter("@Level", (object)item.Level);
                SqlParameters[14] = new SqlParameter("@CardGP", (object)item.CardGP);
                SqlParameters[15] = new SqlParameter("@Type", (object)item.Type);
                flag = this.db.RunProcedure("SP_Users_Cards_Add", SqlParameters);
                item.CardID = (int)SqlParameters[0].Value;
                item.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateCards(UsersCardInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[17]
                {
          new SqlParameter("@CardType", (object) info.CardType),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@Place", (object) info.Place),
          new SqlParameter("@TemplateID", (object) info.TemplateID),
          new SqlParameter("@isFirstGet", (object) info.isFirstGet),
          new SqlParameter("@Attack", (object) info.Attack),
          new SqlParameter("@Defence", (object) info.Defence),
          new SqlParameter("@Luck", (object) info.Luck),
          new SqlParameter("@Agility", (object) info.Agility),
          new SqlParameter("@Damage", (object) info.Damage),
          new SqlParameter("@Guard", (object) info.Guard),
          new SqlParameter("@IsExit", (object) info.IsExit),
          new SqlParameter("@Level", (object) info.Level),
          new SqlParameter("@CardGP", (object) info.CardGP),
          new SqlParameter("@Type", (object) info.Type),
          new SqlParameter("@CardID", (object) info.CardID),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[16].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UserCardProp_Update", SqlParameters);
                flag = (int)SqlParameters[16].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public List<UsersCardInfo> GetUserCardEuqip(int UserID)
        {
            List<UsersCardInfo> userCardEuqip = new List<UsersCardInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Users_Items_Card_Equip", SqlParameters);
                while (ResultDataReader.Read())
                    userCardEuqip.Add(this.InitCard(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return userCardEuqip;
        }

        public UsersCardInfo GetUserCardByPlace(int Place)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@Place", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)Place;
                this.db.GetReader(ref ResultDataReader, "SP_Get_UserCard_By_Place", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitCard(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (UsersCardInfo)null;
        }

        public UsersCardInfo[] GetUserCardSingles(int UserID)
        {
            List<UsersCardInfo> usersCardInfoList = new List<UsersCardInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Get_UserCard_By_ID", SqlParameters);
                while (ResultDataReader.Read())
                    usersCardInfoList.Add(this.InitCard(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return usersCardInfoList.ToArray();
        }

        public UserFarmInfo GetSingleFarm(int Id)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)Id;
                this.db.GetReader(ref ResultDataReader, "SP_Get_SingleFarm", SqlParameters);
                if (ResultDataReader.Read())
                    return new UserFarmInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        FarmID = (int)ResultDataReader["FarmID"],
                        PayFieldMoney = (string)ResultDataReader["PayFieldMoney"],
                        PayAutoMoney = (string)ResultDataReader["PayAutoMoney"],
                        AutoPayTime = (DateTime)ResultDataReader["AutoPayTime"],
                        AutoValidDate = (int)ResultDataReader["AutoValidDate"],
                        VipLimitLevel = (int)ResultDataReader["VipLimitLevel"],
                        FarmerName = (string)ResultDataReader["FarmerName"],
                        GainFieldId = (int)ResultDataReader["GainFieldId"],
                        MatureId = (int)ResultDataReader["MatureId"],
                        KillCropId = (int)ResultDataReader["KillCropId"],
                        isAutoId = (int)ResultDataReader["isAutoId"],
                        isFarmHelper = (bool)ResultDataReader["isFarmHelper"],
                        buyExpRemainNum = (int)ResultDataReader["buyExpRemainNum"],
                        isArrange = (bool)ResultDataReader["isArrange"],
                        TreeLevel = (int)ResultDataReader["TreeLevel"],
                        TreeExp = (int)ResultDataReader["TreeExp"],
                        LoveScore = (int)ResultDataReader["LoveScore"],
                        MonsterExp = (int)ResultDataReader["MonsterExp"],
                        PoultryState = (int)ResultDataReader["PoultryState"],
                        CountDownTime = (DateTime)ResultDataReader["CountDownTime"],
                        TreeCostExp = (int)ResultDataReader["TreeCostExp"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)nameof(GetSingleFarm), ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (UserFarmInfo)null;
        }

        public bool AddFarm(UserFarmInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[22]
                {
          new SqlParameter("@FarmID", (object) info.FarmID),
          new SqlParameter("@PayFieldMoney", (object) info.PayFieldMoney),
          new SqlParameter("@PayAutoMoney", (object) info.PayAutoMoney),
          new SqlParameter("@AutoPayTime", (object) info.AutoPayTime.ToString()),
          new SqlParameter("@AutoValidDate", (object) info.AutoValidDate),
          new SqlParameter("@VipLimitLevel", (object) info.VipLimitLevel),
          new SqlParameter("@FarmerName", (object) info.FarmerName),
          new SqlParameter("@GainFieldId", (object) info.GainFieldId),
          new SqlParameter("@MatureId", (object) info.MatureId),
          new SqlParameter("@KillCropId", (object) info.KillCropId),
          new SqlParameter("@isAutoId", (object) info.isAutoId),
          new SqlParameter("@isFarmHelper", (object) info.isFarmHelper),
          new SqlParameter("@ID", (object) info.ID),
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null
                };
                SqlParameters[12].Direction = ParameterDirection.Output;
                SqlParameters[13] = new SqlParameter("@buyExpRemainNum", (object)info.buyExpRemainNum);
                SqlParameters[14] = new SqlParameter("@isArrange", (object)info.isArrange);
                SqlParameters[15] = new SqlParameter("@TreeLevel", (object)info.TreeLevel);
                SqlParameters[16] = new SqlParameter("@TreeExp", (object)info.TreeExp);
                SqlParameters[17] = new SqlParameter("@LoveScore", (object)info.LoveScore);
                SqlParameters[18] = new SqlParameter("@MonsterExp", (object)info.MonsterExp);
                SqlParameters[19] = new SqlParameter("@PoultryState", (object)info.PoultryState);
                SqlParameters[20] = new SqlParameter("@CountDownTime", (object)info.CountDownTime);
                SqlParameters[21] = new SqlParameter("@TreeCostExp", (object)info.TreeCostExp);
                flag = this.db.RunProcedure("SP_Users_Farm_Add", SqlParameters);
                info.ID = (int)SqlParameters[12].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateFarm(UserFarmInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Users_Farm_Update", new SqlParameter[22]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@FarmID", (object) info.FarmID),
          new SqlParameter("@PayFieldMoney", (object) info.PayFieldMoney),
          new SqlParameter("@PayAutoMoney", (object) info.PayAutoMoney),
          new SqlParameter("@AutoPayTime", (object) info.AutoPayTime.ToString()),
          new SqlParameter("@AutoValidDate", (object) info.AutoValidDate),
          new SqlParameter("@VipLimitLevel", (object) info.VipLimitLevel),
          new SqlParameter("@FarmerName", (object) info.FarmerName),
          new SqlParameter("@GainFieldId", (object) info.GainFieldId),
          new SqlParameter("@MatureId", (object) info.MatureId),
          new SqlParameter("@KillCropId", (object) info.KillCropId),
          new SqlParameter("@isAutoId", (object) info.isAutoId),
          new SqlParameter("@isFarmHelper", (object) info.isFarmHelper),
          new SqlParameter("@buyExpRemainNum", (object) info.buyExpRemainNum),
          new SqlParameter("@isArrange", (object) info.isArrange),
          new SqlParameter("@TreeLevel", (object) info.TreeLevel),
          new SqlParameter("@TreeExp", (object) info.TreeExp),
          new SqlParameter("@LoveScore", (object) info.LoveScore),
          new SqlParameter("@MonsterExp", (object) info.MonsterExp),
          new SqlParameter("@PoultryState", (object) info.PoultryState),
          new SqlParameter("@CountDownTime", (object) info.CountDownTime),
          new SqlParameter("@TreeCostExp", (object) info.TreeCostExp)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool AddFields(UserFieldInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[17]
                {
          new SqlParameter("@FarmID", (object) item.FarmID),
          new SqlParameter("@FieldID", (object) item.FieldID),
          new SqlParameter("@SeedID", (object) item.SeedID),
          new SqlParameter("@PlantTime", (object) item.PlantTime.ToString()),
          new SqlParameter("@AccelerateTime", (object) item.AccelerateTime),
          new SqlParameter("@FieldValidDate", (object) item.FieldValidDate),
          new SqlParameter("@PayTime", (object) item.PayTime.ToString()),
          new SqlParameter("@GainCount", (object) item.GainCount),
          new SqlParameter("@AutoSeedID", (object) item.AutoSeedID),
          new SqlParameter("@AutoFertilizerID", (object) item.AutoFertilizerID),
          new SqlParameter("@AutoSeedIDCount", (object) item.AutoSeedIDCount),
          new SqlParameter("@AutoFertilizerCount", (object) item.AutoFertilizerCount),
          new SqlParameter("@isAutomatic", (object) item.isAutomatic),
          new SqlParameter("@AutomaticTime", (object) item.AutomaticTime.ToString()),
          new SqlParameter("@IsExit", (object) item.IsExit),
          new SqlParameter("@payFieldTime", (object) item.payFieldTime),
          new SqlParameter("@ID", (object) item.ID)
                };
                SqlParameters[16].Direction = ParameterDirection.Output;
                flag = this.db.RunProcedure("SP_Users_Fields_Add", SqlParameters);
                item.ID = (int)SqlParameters[16].Value;
                item.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateFields(UserFieldInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Users_Fields_Update", new SqlParameter[17]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@FarmID", (object) info.FarmID),
          new SqlParameter("@FieldID", (object) info.FieldID),
          new SqlParameter("@SeedID", (object) info.SeedID),
          new SqlParameter("@PlantTime", (object) info.PlantTime.ToString()),
          new SqlParameter("@AccelerateTime", (object) info.AccelerateTime),
          new SqlParameter("@FieldValidDate", (object) info.FieldValidDate),
          new SqlParameter("@PayTime", (object) info.PayTime.ToString()),
          new SqlParameter("@GainCount", (object) info.GainCount),
          new SqlParameter("@AutoSeedID", (object) info.AutoSeedID),
          new SqlParameter("@AutoFertilizerID", (object) info.AutoFertilizerID),
          new SqlParameter("@AutoSeedIDCount", (object) info.AutoSeedIDCount),
          new SqlParameter("@AutoFertilizerCount", (object) info.AutoFertilizerCount),
          new SqlParameter("@isAutomatic", (object) info.isAutomatic),
          new SqlParameter("@AutomaticTime", (object) info.AutomaticTime.ToString()),
          new SqlParameter("@IsExit", (object) info.IsExit),
          new SqlParameter("@payFieldTime", (object) info.payFieldTime)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public UserFieldInfo[] GetSingleFields(int ID)
        {
            List<UserFieldInfo> userFieldInfoList = new List<UserFieldInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)ID;
                this.db.GetReader(ref ResultDataReader, "SP_Get_SingleFields", SqlParameters);
                while (ResultDataReader.Read())
                    userFieldInfoList.Add(new UserFieldInfo()
                    {
                        ID = (int)ResultDataReader[nameof(ID)],
                        FarmID = (int)ResultDataReader["FarmID"],
                        FieldID = (int)ResultDataReader["FieldID"],
                        SeedID = (int)ResultDataReader["SeedID"],
                        PlantTime = (DateTime)ResultDataReader["PlantTime"],
                        AccelerateTime = (int)ResultDataReader["AccelerateTime"],
                        FieldValidDate = (int)ResultDataReader["FieldValidDate"],
                        PayTime = (DateTime)ResultDataReader["PayTime"],
                        GainCount = (int)ResultDataReader["GainCount"],
                        AutoSeedID = (int)ResultDataReader["AutoSeedID"],
                        AutoFertilizerID = (int)ResultDataReader["AutoFertilizerID"],
                        AutoSeedIDCount = (int)ResultDataReader["AutoSeedIDCount"],
                        AutoFertilizerCount = (int)ResultDataReader["AutoFertilizerCount"],
                        isAutomatic = (bool)ResultDataReader["isAutomatic"],
                        AutomaticTime = (DateTime)ResultDataReader["AutomaticTime"],
                        IsExit = (bool)ResultDataReader["IsExit"],
                        payFieldTime = (int)ResultDataReader["payFieldTime"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_GetSingleFields", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return userFieldInfoList.ToArray();
        }

        public bool DeleteAllFields(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
          new SqlParameter("@UserID", (object) ID),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[1].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_RemoveAllFields", SqlParameters);
                flag = (int)SqlParameters[1].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_RemoveAllFields", ex);
            }
            return flag;
        }

        public List<UserGemStone> GetSingleGemStones(int ID)
        {
            List<UserGemStone> singleGemStones = new List<UserGemStone>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)ID;
                this.db.GetReader(ref ResultDataReader, "SP_GetSingleGemStone", SqlParameters);
                while (ResultDataReader.Read())
                    singleGemStones.Add(this.InitGemStones(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_GetSingleUserGemStones", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return singleGemStones;
        }

        public bool AddUserGemStone(UserGemStone item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[6];
                SqlParameters[0] = new SqlParameter("@ID", (object)item.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)item.UserID);
                SqlParameters[2] = new SqlParameter("@FigSpiritId", (object)item.FigSpiritId);
                SqlParameters[3] = new SqlParameter("@FigSpiritIdValue", (object)item.FigSpiritIdValue);
                SqlParameters[4] = new SqlParameter("@EquipPlace", (object)item.EquipPlace);
                SqlParameters[5] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[5].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Users_GemStones_Add", SqlParameters);
                flag = (int)SqlParameters[5].Value == 0;
                item.ID = (int)SqlParameters[0].Value;
                item.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateGemStoneInfo(UserGemStone g)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[6]
                {
          new SqlParameter("@ID", (object) g.ID),
          new SqlParameter("@UserID", (object) g.UserID),
          new SqlParameter("@FigSpiritId", (object) g.FigSpiritId),
          new SqlParameter("@FigSpiritIdValue", (object) g.FigSpiritIdValue),
          new SqlParameter("@EquipPlace", (object) g.EquipPlace),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[5].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UpdateGemStoneInfo", SqlParameters);
                flag = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateGemStoneInfo", ex);
            }
            return flag;
        }

        public UserLabyrinthInfo GetSingleLabyrinth(int ID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)ID;
                this.db.GetReader(ref ResultDataReader, "SP_GetSingleLabyrinth", SqlParameters);
                if (ResultDataReader.Read())
                    return new UserLabyrinthInfo()
                    {
                        UserID = (int)ResultDataReader["UserID"],
                        myProgress = (int)ResultDataReader["myProgress"],
                        myRanking = (int)ResultDataReader["myRanking"],
                        completeChallenge = (bool)ResultDataReader["completeChallenge"],
                        isDoubleAward = (bool)ResultDataReader["isDoubleAward"],
                        currentFloor = (int)ResultDataReader["currentFloor"],
                        accumulateExp = (int)ResultDataReader["accumulateExp"],
                        remainTime = (int)ResultDataReader["remainTime"],
                        currentRemainTime = (int)ResultDataReader["currentRemainTime"],
                        cleanOutAllTime = (int)ResultDataReader["cleanOutAllTime"],
                        cleanOutGold = (int)ResultDataReader["cleanOutGold"],
                        tryAgainComplete = (bool)ResultDataReader["tryAgainComplete"],
                        isInGame = (bool)ResultDataReader["isInGame"],
                        isCleanOut = (bool)ResultDataReader["isCleanOut"],
                        serverMultiplyingPower = (bool)ResultDataReader["serverMultiplyingPower"],
                        LastDate = (DateTime)ResultDataReader["LastDate"],
                        ProcessAward = (string)ResultDataReader["ProcessAward"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_GetSingleUserLabyrinth", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (UserLabyrinthInfo)null;
        }

        public bool AddUserLabyrinth(UserLabyrinthInfo laby)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[18]
                {
          new SqlParameter("@UserID", (object) laby.UserID),
          new SqlParameter("@myProgress", (object) laby.myProgress),
          new SqlParameter("@myRanking", (object) laby.myRanking),
          new SqlParameter("@completeChallenge", (object) laby.completeChallenge),
          new SqlParameter("@isDoubleAward", (object) laby.isDoubleAward),
          new SqlParameter("@currentFloor", (object) laby.currentFloor),
          new SqlParameter("@accumulateExp", (object) laby.accumulateExp),
          new SqlParameter("@remainTime", (object) laby.remainTime),
          new SqlParameter("@currentRemainTime", (object) laby.currentRemainTime),
          new SqlParameter("@cleanOutAllTime", (object) laby.cleanOutAllTime),
          new SqlParameter("@cleanOutGold", (object) laby.cleanOutGold),
          new SqlParameter("@tryAgainComplete", (object) laby.tryAgainComplete),
          new SqlParameter("@isInGame", (object) laby.isInGame),
          new SqlParameter("@isCleanOut", (object) laby.isCleanOut),
          new SqlParameter("@serverMultiplyingPower", (object) laby.serverMultiplyingPower),
          new SqlParameter("@LastDate", (object) laby.LastDate),
          new SqlParameter("@ProcessAward", (object) laby.ProcessAward),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[17].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Users_Labyrinth_Add", SqlParameters);
                flag = (int)SqlParameters[17].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateLabyrinthInfo(UserLabyrinthInfo laby)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[18]
                {
          new SqlParameter("@UserID", (object) laby.UserID),
          new SqlParameter("@myProgress", (object) laby.myProgress),
          new SqlParameter("@myRanking", (object) laby.myRanking),
          new SqlParameter("@completeChallenge", (object) laby.completeChallenge),
          new SqlParameter("@isDoubleAward", (object) laby.isDoubleAward),
          new SqlParameter("@currentFloor", (object) laby.currentFloor),
          new SqlParameter("@accumulateExp", (object) laby.accumulateExp),
          new SqlParameter("@remainTime", (object) laby.remainTime),
          new SqlParameter("@currentRemainTime", (object) laby.currentRemainTime),
          new SqlParameter("@cleanOutAllTime", (object) laby.cleanOutAllTime),
          new SqlParameter("@cleanOutGold", (object) laby.cleanOutGold),
          new SqlParameter("@tryAgainComplete", (object) laby.tryAgainComplete),
          new SqlParameter("@isInGame", (object) laby.isInGame),
          new SqlParameter("@isCleanOut", (object) laby.isCleanOut),
          new SqlParameter("@serverMultiplyingPower", (object) laby.serverMultiplyingPower),
          new SqlParameter("@LastDate", (object) laby.LastDate),
          new SqlParameter("@ProcessAward", (object) laby.ProcessAward),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[17].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UpdateLabyrinthInfo", SqlParameters);
                flag = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateLabyrinthInfo", ex);
            }
            return flag;
        }

        public TotemInfo[] GetAllTotem()
        {
            List<TotemInfo> totemInfoList = new List<TotemInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Totem_All");
                while (ResultDataReader.Read())
                    totemInfoList.Add(new TotemInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        ConsumeExp = (int)ResultDataReader["ConsumeExp"],
                        ConsumeHonor = (int)ResultDataReader["ConsumeHonor"],
                        AddAttack = (int)ResultDataReader["AddAttack"],
                        AddDefence = (int)ResultDataReader["AddDefence"],
                        AddAgility = (int)ResultDataReader["AddAgility"],
                        AddLuck = (int)ResultDataReader["AddLuck"],
                        AddBlood = (int)ResultDataReader["AddBlood"],
                        AddDamage = (int)ResultDataReader["AddDamage"],
                        AddGuard = (int)ResultDataReader["AddGuard"],
                        Random = (int)ResultDataReader["Random"],
                        Page = (int)ResultDataReader["Page"],
                        Layers = (int)ResultDataReader["Layers"],
                        Location = (int)ResultDataReader["Location"],
                        Point = (int)ResultDataReader["Point"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetTotemAll", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return totemInfoList.ToArray();
        }

        public FightSpiritTemplateInfo[] GetAllFightSpiritTemplate()
        {
            List<FightSpiritTemplateInfo> spiritTemplateInfoList = new List<FightSpiritTemplateInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_FightSpiritTemplate_All");
                while (ResultDataReader.Read())
                    spiritTemplateInfoList.Add(new FightSpiritTemplateInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        FightSpiritID = (int)ResultDataReader["FightSpiritID"],
                        FightSpiritIcon = (string)ResultDataReader["FightSpiritIcon"],
                        Level = (int)ResultDataReader["Level"],
                        Exp = (int)ResultDataReader["Exp"],
                        Attack = (int)ResultDataReader["Attack"],
                        Defence = (int)ResultDataReader["Defence"],
                        Agility = (int)ResultDataReader["Agility"],
                        Lucky = (int)ResultDataReader["Lucky"],
                        Blood = (int)ResultDataReader["Blood"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetFightSpiritTemplateAll", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return spiritTemplateInfoList.ToArray();
        }

        public TotemHonorTemplateInfo[] GetAllTotemHonorTemplate()
        {
            List<TotemHonorTemplateInfo> honorTemplateInfoList = new List<TotemHonorTemplateInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_TotemHonorTemplate_All");
                while (ResultDataReader.Read())
                    honorTemplateInfoList.Add(new TotemHonorTemplateInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        NeedMoney = (int)ResultDataReader["NeedMoney"],
                        Type = (int)ResultDataReader["Type"],
                        AddHonor = (int)ResultDataReader["AddHonor"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetTotemHonorTemplateInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return honorTemplateInfoList.ToArray();
        }

        public Dictionary<int, UserDrillInfo> GetPlayerDrillByID(int UserID)
        {
            Dictionary<int, UserDrillInfo> playerDrillById = new Dictionary<int, UserDrillInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Users_Drill_All", SqlParameters);
                while (ResultDataReader.Read())
                {
                    UserDrillInfo userDrillInfo = new UserDrillInfo();
                    userDrillInfo.UserID = (int)ResultDataReader[nameof(UserID)];
                    userDrillInfo.BeadPlace = (int)ResultDataReader["BeadPlace"];
                    userDrillInfo.HoleLv = (int)ResultDataReader["HoleLv"];
                    userDrillInfo.HoleExp = (int)ResultDataReader["HoleExp"];
                    userDrillInfo.DrillPlace = (int)ResultDataReader["DrillPlace"];
                    if (!playerDrillById.ContainsKey(userDrillInfo.DrillPlace))
                        playerDrillById.Add(userDrillInfo.DrillPlace, userDrillInfo);
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return playerDrillById;
        }

        public bool AddUserUserDrill(UserDrillInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[6]
                {
          new SqlParameter("@UserID", (object) item.UserID),
          new SqlParameter("@BeadPlace", (object) item.BeadPlace),
          new SqlParameter("@HoleExp", (object) item.HoleExp),
          new SqlParameter("@HoleLv", (object) item.HoleLv),
          new SqlParameter("@DrillPlace", (object) item.DrillPlace),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[5].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Users_UserDrill_Add", SqlParameters);
                flag = (int)SqlParameters[5].Value == 0;
                item.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateUserDrillInfo(UserDrillInfo g)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[6]
                {
          new SqlParameter("@UserID", (object) g.UserID),
          new SqlParameter("@BeadPlace", (object) g.BeadPlace),
          new SqlParameter("@HoleExp", (object) g.HoleExp),
          new SqlParameter("@HoleLv", (object) g.HoleLv),
          new SqlParameter("@DrillPlace", (object) g.DrillPlace),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[5].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UpdateUserDrillInfo", SqlParameters);
                flag = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateUserDrillInfo", ex);
            }
            return flag;
        }

        public TreasureAwardInfo[] GetAllTreasureAward()
        {
            List<TreasureAwardInfo> treasureAwardInfoList = new List<TreasureAwardInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Treasure_All");
                while (ResultDataReader.Read())
                    treasureAwardInfoList.Add(new TreasureAwardInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        TemplateID = (int)ResultDataReader["TemplateID"],
                        Name = (string)ResultDataReader["Name"],
                        Count = (int)ResultDataReader["Count"],
                        Validate = (int)ResultDataReader["Validate"],
                        Random = (int)ResultDataReader["Random"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetTreasureAwardAll", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return treasureAwardInfoList.ToArray();
        }

        public UserTreasureInfo GetSingleTreasure(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_GetSingleTreasure", SqlParameters);
                if (ResultDataReader.Read())
                    return new UserTreasureInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        UserID = (int)ResultDataReader[nameof(UserID)],
                        NickName = (string)ResultDataReader["NickName"],
                        logoinDays = (int)ResultDataReader["logoinDays"],
                        treasure = (int)ResultDataReader["treasure"],
                        treasureAdd = (int)ResultDataReader["treasureAdd"],
                        friendHelpTimes = (int)ResultDataReader["friendHelpTimes"],
                        isEndTreasure = (bool)ResultDataReader["isEndTreasure"],
                        isBeginTreasure = (bool)ResultDataReader["isBeginTreasure"],
                        LastLoginDay = (DateTime)ResultDataReader["LastLoginDay"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_GetSingleTreasure", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (UserTreasureInfo)null;
        }

        public List<TreasureDataInfo> GetSingleTreasureData(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            List<TreasureDataInfo> singleTreasureData = new List<TreasureDataInfo>();
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_GetSingleTreasureData", SqlParameters);
                while (ResultDataReader.Read())
                    singleTreasureData.Add(new TreasureDataInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        UserID = (int)ResultDataReader[nameof(UserID)],
                        TemplateID = (int)ResultDataReader["TemplateID"],
                        Count = (int)ResultDataReader["Count"],
                        ValidDate = (int)ResultDataReader["Validate"],
                        pos = (int)ResultDataReader["pos"],
                        BeginDate = (DateTime)ResultDataReader["BeginDate"],
                        IsExit = (bool)ResultDataReader["IsExit"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_GetSingleTreasureData", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return singleTreasureData;
        }

        public bool AddUserTreasureInfo(UserTreasureInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[11];
                SqlParameters[0] = new SqlParameter("@ID", (object)item.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)item.UserID);
                SqlParameters[2] = new SqlParameter("@NickName", (object)item.NickName);
                SqlParameters[3] = new SqlParameter("@logoinDays", (object)item.logoinDays);
                SqlParameters[4] = new SqlParameter("@treasure", (object)item.treasure);
                SqlParameters[5] = new SqlParameter("@treasureAdd", (object)item.treasureAdd);
                SqlParameters[6] = new SqlParameter("@friendHelpTimes", (object)item.friendHelpTimes);
                SqlParameters[7] = new SqlParameter("@isEndTreasure", (object)item.isEndTreasure);
                SqlParameters[8] = new SqlParameter("@isBeginTreasure", (object)item.isBeginTreasure);
                SqlParameters[9] = new SqlParameter("@LastLoginDay", (object)item.LastLoginDay);
                SqlParameters[10] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[10].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Users_Treasure_Add", SqlParameters);
                flag = (int)SqlParameters[10].Value == 0;
                item.ID = (int)SqlParameters[0].Value;
                item.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateUserTreasureInfo(UserTreasureInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[10]
                {
          new SqlParameter("@UserID", (object) item.UserID),
          new SqlParameter("@NickName", (object) item.NickName),
          new SqlParameter("@logoinDays", (object) item.logoinDays),
          new SqlParameter("@treasure", (object) item.treasure),
          new SqlParameter("@treasureAdd", (object) item.treasureAdd),
          new SqlParameter("@friendHelpTimes", (object) item.friendHelpTimes),
          new SqlParameter("@isEndTreasure", (object) item.isEndTreasure),
          new SqlParameter("@isBeginTreasure", (object) item.isBeginTreasure),
          new SqlParameter("@LastLoginDay", (object) item.LastLoginDay),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[9].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UpdateUserTreasure", SqlParameters);
                flag = (int)SqlParameters[9].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateUserTreasure", ex);
            }
            return flag;
        }

        public bool AddTreasureData(TreasureDataInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[9];
                SqlParameters[0] = new SqlParameter("@ID", (object)item.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)item.UserID);
                SqlParameters[2] = new SqlParameter("@TemplateID", (object)item.TemplateID);
                SqlParameters[3] = new SqlParameter("@Count", (object)item.Count);
                SqlParameters[4] = new SqlParameter("@Validate", (object)item.ValidDate);
                SqlParameters[5] = new SqlParameter("@Pos", (object)item.pos);
                SqlParameters[6] = new SqlParameter("@BeginDate", (object)item.BeginDate);
                SqlParameters[7] = new SqlParameter("@IsExit", (object)item.IsExit);
                SqlParameters[8] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[8].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_TreasureData_Add", SqlParameters);
                flag = (int)SqlParameters[8].Value == 0;
                item.ID = (int)SqlParameters[0].Value;
                item.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateTreasureData(TreasureDataInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[9]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@UserID", (object) item.UserID),
          new SqlParameter("@TemplateID", (object) item.TemplateID),
          new SqlParameter("@Count", (object) item.Count),
          new SqlParameter("@Validate", (object) item.ValidDate),
          new SqlParameter("@Pos", (object) item.pos),
          new SqlParameter("@BeginDate", (object) item.BeginDate),
          new SqlParameter("@IsExit", (object) item.IsExit),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[8].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UpdateTreasureData", SqlParameters);
                flag = (int)SqlParameters[8].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateTreasureData", ex);
            }
            return flag;
        }

        public bool RemoveTreasureDataByUser(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
          new SqlParameter("@UserID", (object) ID),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[1].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_RemoveTreasureDataByUser", SqlParameters);
                flag = (int)SqlParameters[1].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_RemoveTreasureDataByUser", ex);
            }
            return flag;
        }

        public bool RemoveIsArrange(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
          new SqlParameter("@UserID", (object) ID),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[1].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_RemoveIsArrange", SqlParameters);
                flag = (int)SqlParameters[1].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_RemoveIsArrange", ex);
            }
            return flag;
        }

        public bool UpdateFriendHelpTimes(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
          new SqlParameter("@UserID", (object) ID),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[1].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UpdateFriendHelpTimes", SqlParameters);
                flag = (int)SqlParameters[1].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateFriendHelpTimes", ex);
            }
            return flag;
        }

        public UsersExtraInfo GetSingleUsersExtra(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_GetSingleUsersExtra", SqlParameters);
                if (ResultDataReader.Read())
                    return new UsersExtraInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        UserID = (int)ResultDataReader[nameof(UserID)],
                        starlevel = (int)ResultDataReader["starlevel"],
                        nowPosition = (int)ResultDataReader["nowPosition"],
                        FreeCount = (int)ResultDataReader["FreeCount"],
                        SearchGoodItems = ResultDataReader["SearchGoodItems"] == null ? "" : ResultDataReader["SearchGoodItems"].ToString(),
                        FreeAddAutionCount = (int)ResultDataReader["FreeAddAutionCount"],
                        FreeSendMailCount = (int)ResultDataReader["FreeSendMailCount"],
                        KingBlessInfo = ResultDataReader["KingBlessInfo"] == null ? "" : ResultDataReader["KingBlessInfo"].ToString(),
                        MissionEnergy = (int)ResultDataReader["MissionEnergy"],
                        buyEnergyCount = (int)ResultDataReader["buyEnergyCount"],
                        KingBlessEnddate = (DateTime)ResultDataReader["KingBlessEnddate"],
                        KingBlessIndex = (int)ResultDataReader["KingBlessIndex"],
                        DressModelArr = ResultDataReader["DressModelArr"] == null ? ",," : ResultDataReader["DressModelArr"].ToString(),
                        CurentDressModel = (int)ResultDataReader["CurentDressModel"],
                        ScoreMagicstone = (int)ResultDataReader["ScoreMagicstone"],
                        DeedInfo = ResultDataReader["DeedInfo"] == null ? "" : ResultDataReader["DeedInfo"].ToString(),
                        DeedEnddate = (DateTime)ResultDataReader["DeedEnddate"],
                        DeedIndex = (int)ResultDataReader["DeedIndex"],
                        Score = (int)ResultDataReader["Score"],
                        SummerScore = (int)ResultDataReader["SummerScore"],
                        CatchInsectGetPrize = ResultDataReader["CatchInsectGetPrize"] == null ? "" : ResultDataReader["CatchInsectGetPrize"].ToString(),
                        PrizeStatus = (int)ResultDataReader["PrizeStatus"],
                        CakeStatus = (bool)ResultDataReader["CakeStatus"],
                        NormalFightNum = (int)ResultDataReader["NormalFightNum"],
                        HardFightNum = (int)ResultDataReader["HardFightNum"],
                        IsDoubleScore = (bool)ResultDataReader["IsDoubleScore"],
                        MagpieBridgeItems = ResultDataReader["MagpieBridgeItems"] == null ? "" : ResultDataReader["MagpieBridgeItems"].ToString(),
                        NowPositionMB = (int)ResultDataReader["NowPositionMB"],
                        LastNum = (int)ResultDataReader["LastNum"],
                        MagpieNum = (int)ResultDataReader["MagpieNum"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_GetSingleUsersExtra", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (UsersExtraInfo)null;
        }

        public bool AddUsersExtra(UsersExtraInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[32];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)info.UserID);
                SqlParameters[2] = new SqlParameter("@starlevel", (object)info.starlevel);
                SqlParameters[3] = new SqlParameter("@nowPosition", (object)info.nowPosition);
                SqlParameters[4] = new SqlParameter("@FreeCount", (object)info.FreeCount);
                SqlParameters[5] = new SqlParameter("@SearchGoodItems", (object)info.SearchGoodItems);
                SqlParameters[6] = new SqlParameter("@FreeAddAutionCount", (object)info.FreeAddAutionCount);
                SqlParameters[7] = new SqlParameter("@FreeSendMailCount", (object)info.FreeSendMailCount);
                SqlParameters[8] = new SqlParameter("@KingBlessInfo", (object)info.KingBlessInfo);
                SqlParameters[9] = new SqlParameter("@MissionEnergy", (object)info.MissionEnergy);
                SqlParameters[10] = new SqlParameter("@buyEnergyCount", (object)info.buyEnergyCount);
                SqlParameters[11] = new SqlParameter("@KingBlessEnddate", (object)info.KingBlessEnddate);
                SqlParameters[12] = new SqlParameter("@KingBlessIndex", (object)info.KingBlessIndex);
                SqlParameters[13] = new SqlParameter("@DressModelArr", (object)info.DressModelArr);
                SqlParameters[14] = new SqlParameter("@CurentDressModel", (object)info.CurentDressModel);
                SqlParameters[15] = new SqlParameter("@ScoreMagicstone", (object)info.ScoreMagicstone);
                SqlParameters[16] = new SqlParameter("@DeedInfo", (object)info.DeedInfo);
                SqlParameters[17] = new SqlParameter("@DeedEnddate", (object)info.DeedEnddate);
                SqlParameters[18] = new SqlParameter("@DeedIndex", (object)info.DeedIndex);
                SqlParameters[19] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[19].Direction = ParameterDirection.ReturnValue;
                SqlParameters[20] = new SqlParameter("@Score", (object)info.Score);
                SqlParameters[21] = new SqlParameter("@SummerScore", (object)info.SummerScore);
                SqlParameters[22] = new SqlParameter("@CatchInsectGetPrize", (object)info.CatchInsectGetPrize);
                SqlParameters[23] = new SqlParameter("@PrizeStatus", (object)info.PrizeStatus);
                SqlParameters[24] = new SqlParameter("@CakeStatus", (object)info.CakeStatus);
                SqlParameters[25] = new SqlParameter("@NormalFightNum", (object)info.NormalFightNum);
                SqlParameters[26] = new SqlParameter("@HardFightNum", (object)info.HardFightNum);
                SqlParameters[27] = new SqlParameter("@IsDoubleScore", (object)info.IsDoubleScore);
                SqlParameters[28] = new SqlParameter("@MagpieBridgeItems", (object)info.MagpieBridgeItems);
                SqlParameters[29] = new SqlParameter("@NowPositionMB", (object)info.NowPositionMB);
                SqlParameters[30] = new SqlParameter("@LastNum", (object)info.LastNum);
                SqlParameters[31] = new SqlParameter("@MagpieNum", (object)info.MagpieNum);
                this.db.RunProcedure("SP_UsersExtra_Add", SqlParameters);
                flag = (int)SqlParameters[19].Value == 0;
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UsersExtra_Add", ex);
            }
            return flag;
        }

        public bool UpdateUsersExtra(UsersExtraInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[32]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@starlevel", (object) info.starlevel),
          new SqlParameter("@nowPosition", (object) info.nowPosition),
          new SqlParameter("@FreeCount", (object) info.FreeCount),
          new SqlParameter("@SearchGoodItems", (object) info.SearchGoodItems),
          new SqlParameter("@FreeAddAutionCount", (object) info.FreeAddAutionCount),
          new SqlParameter("@FreeSendMailCount", (object) info.FreeSendMailCount),
          new SqlParameter("@KingBlessInfo", (object) info.KingBlessInfo),
          new SqlParameter("@MissionEnergy", (object) info.MissionEnergy),
          new SqlParameter("@buyEnergyCount", (object) info.buyEnergyCount),
          new SqlParameter("@KingBlessEnddate", (object) info.KingBlessEnddate),
          new SqlParameter("@KingBlessIndex", (object) info.KingBlessIndex),
          new SqlParameter("@DressModelArr", (object) info.DressModelArr),
          new SqlParameter("@CurentDressModel", (object) info.CurentDressModel),
          new SqlParameter("@ScoreMagicstone", (object) info.ScoreMagicstone),
          new SqlParameter("@DeedInfo", (object) info.DeedInfo),
          new SqlParameter("@DeedEnddate", (object) info.DeedEnddate),
          new SqlParameter("@DeedIndex", (object) info.DeedIndex),
          new SqlParameter("@Result", SqlDbType.Int),
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null
                };
                SqlParameters[19].Direction = ParameterDirection.ReturnValue;
                SqlParameters[20] = new SqlParameter("@Score", (object)info.Score);
                SqlParameters[21] = new SqlParameter("@SummerScore", (object)info.SummerScore);
                SqlParameters[22] = new SqlParameter("@CatchInsectGetPrize", (object)info.CatchInsectGetPrize);
                SqlParameters[23] = new SqlParameter("@PrizeStatus", (object)info.PrizeStatus);
                SqlParameters[24] = new SqlParameter("@CakeStatus", (object)info.CakeStatus);
                SqlParameters[25] = new SqlParameter("@NormalFightNum", (object)info.NormalFightNum);
                SqlParameters[26] = new SqlParameter("@HardFightNum", (object)info.HardFightNum);
                SqlParameters[27] = new SqlParameter("@IsDoubleScore", (object)info.IsDoubleScore);
                SqlParameters[28] = new SqlParameter("@MagpieBridgeItems", (object)info.MagpieBridgeItems);
                SqlParameters[29] = new SqlParameter("@NowPositionMB", (object)info.NowPositionMB);
                SqlParameters[30] = new SqlParameter("@LastNum", (object)info.LastNum);
                SqlParameters[31] = new SqlParameter("@MagpieNum", (object)info.MagpieNum);
                this.db.RunProcedure("SP_UpdateUsersExtra", SqlParameters);
                flag = (int)SqlParameters[19].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateUsersExtra", ex);
            }
            return flag;
        }

        public PyramidInfo GetSinglePyramid(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_GetSinglePyramid", SqlParameters);
                if (ResultDataReader.Read())
                    return new PyramidInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        UserID = (int)ResultDataReader[nameof(UserID)],
                        currentLayer = (int)ResultDataReader["currentLayer"],
                        maxLayer = (int)ResultDataReader["maxLayer"],
                        totalPoint = (int)ResultDataReader["totalPoint"],
                        turnPoint = (int)ResultDataReader["turnPoint"],
                        pointRatio = (int)ResultDataReader["pointRatio"],
                        currentFreeCount = (int)ResultDataReader["currentFreeCount"],
                        currentReviveCount = (int)ResultDataReader["currentReviveCount"],
                        isPyramidStart = (bool)ResultDataReader["isPyramidStart"],
                        LayerItems = (string)ResultDataReader["LayerItems"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_GetSinglePyramid", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (PyramidInfo)null;
        }

        public bool AddPyramid(PyramidInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[12];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)info.UserID);
                SqlParameters[2] = new SqlParameter("@currentLayer", (object)info.currentLayer);
                SqlParameters[3] = new SqlParameter("@maxLayer", (object)info.maxLayer);
                SqlParameters[4] = new SqlParameter("@totalPoint", (object)info.totalPoint);
                SqlParameters[5] = new SqlParameter("@turnPoint", (object)info.turnPoint);
                SqlParameters[6] = new SqlParameter("@pointRatio", (object)info.pointRatio);
                SqlParameters[7] = new SqlParameter("@currentFreeCount", (object)info.currentFreeCount);
                SqlParameters[8] = new SqlParameter("@currentReviveCount", (object)info.currentReviveCount);
                SqlParameters[9] = new SqlParameter("@isPyramidStart", (object)info.isPyramidStart);
                SqlParameters[10] = new SqlParameter("@LayerItems", (object)info.LayerItems);
                SqlParameters[11] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[11].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Pyramid_Add", SqlParameters);
                flag = (int)SqlParameters[11].Value == 0;
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Pyramid_Add", ex);
            }
            return flag;
        }

        public bool UpdatePyramid(PyramidInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[12]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@currentLayer", (object) info.currentLayer),
          new SqlParameter("@maxLayer", (object) info.maxLayer),
          new SqlParameter("@totalPoint", (object) info.totalPoint),
          new SqlParameter("@turnPoint", (object) info.turnPoint),
          new SqlParameter("@pointRatio", (object) info.pointRatio),
          new SqlParameter("@currentFreeCount", (object) info.currentFreeCount),
          new SqlParameter("@currentReviveCount", (object) info.currentReviveCount),
          new SqlParameter("@isPyramidStart", (object) info.isPyramidStart),
          new SqlParameter("@LayerItems", (object) info.LayerItems),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[11].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UpdatePyramid", SqlParameters);
                flag = (int)SqlParameters[11].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdatePyramid", ex);
            }
            return flag;
        }

        public UserAvatarColectionInfo[] GetSingleUserAvatarColectionInfo(int UserID)
        {
            List<UserAvatarColectionInfo> avatarColectionInfoList = new List<UserAvatarColectionInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Get_Single_User_Avatar_Colection", SqlParameters);
                while (ResultDataReader.Read())
                    avatarColectionInfoList.Add(new UserAvatarColectionInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        UserID = (int)ResultDataReader[nameof(UserID)],
                        endTime = (DateTime)ResultDataReader["endTime"],
                        dataId = (int)ResultDataReader["dataId"],
                        ActiveCount = (int)ResultDataReader["ActiveCount"],
                        Sex = (int)ResultDataReader["Sex"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Get_Single_User_Avatar_Colection", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return avatarColectionInfoList.ToArray();
        }

        public bool AddUserAvatarColectionInfo(UserAvatarColectionInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[7];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)info.UserID);
                SqlParameters[2] = new SqlParameter("@endTime", (object)info.endTime);
                SqlParameters[3] = new SqlParameter("@dataId", (object)info.dataId);
                SqlParameters[4] = new SqlParameter("@ActiveCount", (object)info.ActiveCount);
                SqlParameters[5] = new SqlParameter("@Sex", (object)info.Sex);
                SqlParameters[6] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[6].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_User_Avatar_Colection_Add", SqlParameters);
                flag = (int)SqlParameters[6].Value == 0;
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_User_Avatar_Colection_Add", ex);
            }
            return flag;
        }

        public bool UpdateUserAvatarColectionInfo(UserAvatarColectionInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[7]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@endTime", (object) info.endTime),
          new SqlParameter("@dataId", (object) info.dataId),
          new SqlParameter("@ActiveCount", (object) info.ActiveCount),
          new SqlParameter("@Sex", (object) info.Sex),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[6].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_User_Avatar_Colection_Update", SqlParameters);
                flag = (int)SqlParameters[6].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_User_Avatar_Colection_Update", ex);
            }
            return flag;
        }

        public NewChickenBoxItemInfo[] GetSingleNewChickenBox(int UserID)
        {
            List<NewChickenBoxItemInfo> chickenBoxItemInfoList = new List<NewChickenBoxItemInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_GetSingleNewChickenBox", SqlParameters);
                while (ResultDataReader.Read())
                    chickenBoxItemInfoList.Add(new NewChickenBoxItemInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        UserID = (int)ResultDataReader[nameof(UserID)],
                        TemplateID = (int)ResultDataReader["TemplateID"],
                        Count = (int)ResultDataReader["Count"],
                        ValidDate = (int)ResultDataReader["ValidDate"],
                        StrengthenLevel = (int)ResultDataReader["StrengthenLevel"],
                        AttackCompose = (int)ResultDataReader["AttackCompose"],
                        DefendCompose = (int)ResultDataReader["DefendCompose"],
                        AgilityCompose = (int)ResultDataReader["AgilityCompose"],
                        LuckCompose = (int)ResultDataReader["LuckCompose"],
                        Position = (int)ResultDataReader["Position"],
                        IsSelected = (bool)ResultDataReader["IsSelected"],
                        IsSeeded = (bool)ResultDataReader["IsSeeded"],
                        IsBinds = (bool)ResultDataReader["IsBinds"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_GetSingleNewChickenBox", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return chickenBoxItemInfoList.ToArray();
        }

        public bool AddNewChickenBox(NewChickenBoxItemInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[15];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)info.UserID);
                SqlParameters[2] = new SqlParameter("@TemplateID", (object)info.TemplateID);
                SqlParameters[3] = new SqlParameter("@Count", (object)info.Count);
                SqlParameters[4] = new SqlParameter("@ValidDate", (object)info.ValidDate);
                SqlParameters[5] = new SqlParameter("@StrengthenLevel", (object)info.StrengthenLevel);
                SqlParameters[6] = new SqlParameter("@AttackCompose", (object)info.AttackCompose);
                SqlParameters[7] = new SqlParameter("@DefendCompose", (object)info.DefendCompose);
                SqlParameters[8] = new SqlParameter("@AgilityCompose", (object)info.AgilityCompose);
                SqlParameters[9] = new SqlParameter("@LuckCompose", (object)info.LuckCompose);
                SqlParameters[10] = new SqlParameter("@Position", (object)info.Position);
                SqlParameters[11] = new SqlParameter("@IsSelected", (object)info.IsSelected);
                SqlParameters[12] = new SqlParameter("@IsSeeded", (object)info.IsSeeded);
                SqlParameters[13] = new SqlParameter("@IsBinds", (object)info.IsBinds);
                SqlParameters[14] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[14].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_NewChickenBox_Add", SqlParameters);
                flag = (int)SqlParameters[14].Value == 0;
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_NewChickenBox_Add", ex);
            }
            return flag;
        }

        public bool UpdateNewChickenBox(NewChickenBoxItemInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[15]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@TemplateID", (object) info.TemplateID),
          new SqlParameter("@Count", (object) info.Count),
          new SqlParameter("@ValidDate", (object) info.ValidDate),
          new SqlParameter("@StrengthenLevel", (object) info.StrengthenLevel),
          new SqlParameter("@AttackCompose", (object) info.AttackCompose),
          new SqlParameter("@DefendCompose", (object) info.DefendCompose),
          new SqlParameter("@AgilityCompose", (object) info.AgilityCompose),
          new SqlParameter("@LuckCompose", (object) info.LuckCompose),
          new SqlParameter("@Position", (object) info.Position),
          new SqlParameter("@IsSelected", (object) info.IsSelected),
          new SqlParameter("@IsSeeded", (object) info.IsSeeded),
          new SqlParameter("@IsBinds", (object) info.IsBinds),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[14].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UpdateNewChickenBox", SqlParameters);
                flag = (int)SqlParameters[14].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateNewChickenBox", ex);
            }
            return flag;
        }

        public UserChristmasInfo GetSingleUserChristmas(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_GetSingleUserChristmas", SqlParameters);
                if (ResultDataReader.Read())
                    return new UserChristmasInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        UserID = (int)ResultDataReader[nameof(UserID)],
                        exp = (int)ResultDataReader["exp"],
                        awardState = (int)ResultDataReader["awardState"],
                        count = (int)ResultDataReader["count"],
                        packsNumber = (int)ResultDataReader["packsNumber"],
                        lastPacks = (int)ResultDataReader["lastPacks"],
                        gameBeginTime = (DateTime)ResultDataReader["gameBeginTime"],
                        gameEndTime = (DateTime)ResultDataReader["gameEndTime"],
                        isEnter = (bool)ResultDataReader["isEnter"],
                        dayPacks = (int)ResultDataReader["dayPacks"],
                        AvailTime = (int)ResultDataReader["AvailTime"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_GetSingleUserChristmas", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (UserChristmasInfo)null;
        }

        public bool AddUserChristmas(UserChristmasInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[13];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)info.UserID);
                SqlParameters[2] = new SqlParameter("@exp", (object)info.exp);
                SqlParameters[3] = new SqlParameter("@awardState", (object)info.awardState);
                SqlParameters[4] = new SqlParameter("@count", (object)info.count);
                SqlParameters[5] = new SqlParameter("@packsNumber", (object)info.packsNumber);
                SqlParameters[6] = new SqlParameter("@lastPacks", (object)info.lastPacks);
                SqlParameters[7] = new SqlParameter("@gameBeginTime", (object)info.gameBeginTime);
                SqlParameters[8] = new SqlParameter("@gameEndTime", (object)info.gameEndTime);
                SqlParameters[9] = new SqlParameter("@isEnter", (object)info.isEnter);
                SqlParameters[10] = new SqlParameter("@dayPacks", (object)info.dayPacks);
                SqlParameters[11] = new SqlParameter("@AvailTime", (object)info.AvailTime);
                SqlParameters[12] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[12].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UserChristmas_Add", SqlParameters);
                flag = (int)SqlParameters[12].Value == 0;
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateUserChristmas(UserChristmasInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[13]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@exp", (object) info.exp),
          new SqlParameter("@awardState", (object) info.awardState),
          new SqlParameter("@count", (object) info.count),
          new SqlParameter("@packsNumber", (object) info.packsNumber),
          new SqlParameter("@lastPacks", (object) info.lastPacks),
          new SqlParameter("@gameBeginTime", (object) info.gameBeginTime),
          new SqlParameter("@gameEndTime", (object) info.gameEndTime),
          new SqlParameter("@isEnter", (object) info.isEnter),
          new SqlParameter("@dayPacks", (object) info.dayPacks),
          new SqlParameter("@AvailTime", (object) info.AvailTime),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[12].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UpdateUserChristmas", SqlParameters);
                flag = (int)SqlParameters[12].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateUserChristmas", ex);
            }
            return flag;
        }

        public bool ResetDragonBoat()
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Reset_DragonBoat_Data");
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init SP_Reset_DragonBoat_Data", ex);
            }
            return flag;
        }

        public bool CompleteSendDragonBoatAward()
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Complete_Send_DragonBoat_Award");
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init SP_Complete_Send_DragonBoat_Award", ex);
            }
            return flag;
        }

        public bool ResetCommunalActive(int ActiveID, bool IsReset)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[3]
                {
          new SqlParameter("@ActiveID", (object) ActiveID),
          new SqlParameter("@IsReset", (object) IsReset),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[2].Direction = ParameterDirection.ReturnValue;
                flag = this.db.RunProcedure("SP_Reset_CommunalActive", SqlParameters);
                flag = (int)SqlParameters[2].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init CommunalActive", ex);
            }
            return flag;
        }

        public LuckyStartToptenAwardInfo[] GetAllLuckyStartToptenAward()
        {
            List<LuckyStartToptenAwardInfo> startToptenAwardInfoList = new List<LuckyStartToptenAwardInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_LuckyStart_Topten_Award_All");
                while (ResultDataReader.Read())
                    startToptenAwardInfoList.Add(new LuckyStartToptenAwardInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        Type = (int)ResultDataReader["Type"],
                        TemplateID = (int)ResultDataReader["TemplateID"],
                        Validate = (int)ResultDataReader["Validate"],
                        Count = (int)ResultDataReader["Count"],
                        StrengthenLevel = (int)ResultDataReader["StrengthenLevel"],
                        AttackCompose = (int)ResultDataReader["AttackCompose"],
                        DefendCompose = (int)ResultDataReader["DefendCompose"],
                        AgilityCompose = (int)ResultDataReader["AgilityCompose"],
                        LuckCompose = (int)ResultDataReader["LuckCompose"],
                        IsBinds = (bool)ResultDataReader["IsBind"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetLuckyStart_Topten_Award_All", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return startToptenAwardInfoList.ToArray();
        }

        public LuckyStartToptenAwardInfo[] GetAllLanternriddlesTopTenAward()
        {
            List<LuckyStartToptenAwardInfo> startToptenAwardInfoList = new List<LuckyStartToptenAwardInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_LanternriddlesTopTenAward_All");
                while (ResultDataReader.Read())
                    startToptenAwardInfoList.Add(new LuckyStartToptenAwardInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        Type = (int)ResultDataReader["Type"],
                        TemplateID = (int)ResultDataReader["TemplateID"],
                        Validate = (int)ResultDataReader["Validate"],
                        Count = (int)ResultDataReader["Count"],
                        StrengthenLevel = (int)ResultDataReader["StrengthenLevel"],
                        AttackCompose = (int)ResultDataReader["AttackCompose"],
                        DefendCompose = (int)ResultDataReader["DefendCompose"],
                        AgilityCompose = (int)ResultDataReader["AgilityCompose"],
                        LuckCompose = (int)ResultDataReader["LuckCompose"],
                        IsBinds = (bool)ResultDataReader["IsBind"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetLuckyStart_Topten_Award_All", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return startToptenAwardInfoList.ToArray();
        }

        public ActiveSystemInfo[] GetAllActiveSystemData()
        {
            List<ActiveSystemInfo> activeSystemInfoList = new List<ActiveSystemInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_ActiveSystem_All");
                while (ResultDataReader.Read())
                    activeSystemInfoList.Add(this.InitActiveSystemInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetAllActiveSystem", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return activeSystemInfoList.ToArray();
        }

        public TreasurePuzzleDataInfo[] GetAllTreasurePuzzleDataByID(int UserID)
        {
            List<TreasurePuzzleDataInfo> treasurePuzzleDataInfoList = new List<TreasurePuzzleDataInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_Treasure_Puzzle_Data_All_ByID", SqlParameters);
                while (ResultDataReader.Read())
                    treasurePuzzleDataInfoList.Add(this.InitTreasurePuzzleDataInfo(ResultDataReader));
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"InitTreasurePuzzleDataInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return treasurePuzzleDataInfoList.ToArray();
        }

        public bool UpdateTreasurePuzzleData(TreasurePuzzleDataInfo info)
        {
            bool flag = false;
            try
            {
                flag = this.db.RunProcedure("SP_Treasure_Puzzle_Data_Update", new SqlParameter[16]
                {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@PuzzleID", (object) info.PuzzleID),
          new SqlParameter("@hole1Need", (object) info.Int32_0),
          new SqlParameter("@hole1Have", (object) info.Int32_1),
          new SqlParameter("@hole2Need", (object) info.Int32_2),
          new SqlParameter("@hole2Have", (object) info.Int32_3),
          new SqlParameter("@hole3Need", (object) info.Int32_4),
          new SqlParameter("@hole3Have", (object) info.Int32_5),
          new SqlParameter("@hole4Need", (object) info.Int32_6),
          new SqlParameter("@hole4Have", (object) info.Int32_7),
          new SqlParameter("@hole5Need", (object) info.Int32_8),
          new SqlParameter("@hole5Have", (object) info.Int32_9),
          new SqlParameter("@hole6Need", (object) info.Int32_10),
          new SqlParameter("@hole6Have", (object) info.Int32_11),
          new SqlParameter("@IsGetAward", (object) info.IsGetAward),
          new SqlParameter("@ID", (object) info.ID)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Treasure_Puzzle_Data_Update", ex);
            }
            return flag;
        }

        public bool AddTreasurePuzzleData(TreasurePuzzleDataInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[16]
                {
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@PuzzleID", (object) info.PuzzleID),
          new SqlParameter("@hole1Need", (object) info.Int32_0),
          new SqlParameter("@hole1Have", (object) info.Int32_1),
          new SqlParameter("@hole2Need", (object) info.Int32_2),
          new SqlParameter("@hole2Have", (object) info.Int32_3),
          new SqlParameter("@hole3Need", (object) info.Int32_4),
          new SqlParameter("@hole3Have", (object) info.Int32_5),
          new SqlParameter("@hole4Need", (object) info.Int32_6),
          new SqlParameter("@hole4Have", (object) info.Int32_7),
          new SqlParameter("@hole5Need", (object) info.Int32_8),
          new SqlParameter("@hole5Have", (object) info.Int32_9),
          new SqlParameter("@hole6Need", (object) info.Int32_10),
          new SqlParameter("@hole6Have", (object) info.Int32_11),
          new SqlParameter("@IsGetAward", (object) info.IsGetAward),
          new SqlParameter("@ID", (object) info.ID)
                };
                SqlParameters[15].Direction = ParameterDirection.Output;
                flag = this.db.RunProcedure("SP_Treasure_Puzzle_Data_Add", SqlParameters);
                info.ID = (int)SqlParameters[15].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Treasure_Puzzle_Data_Add", ex);
            }
            return flag;
        }

        public TreasurePuzzleDataInfo InitTreasurePuzzleDataInfo(SqlDataReader dr)
        {
            return new TreasurePuzzleDataInfo()
            {
                ID = (int)dr["ID"],
                UserID = (int)dr["UserID"],
                PuzzleID = (int)dr["PuzzleID"],
                Int32_0 = (int)dr["hole1Need"],
                Int32_1 = (int)dr["hole1Have"],
                Int32_2 = (int)dr["hole2Need"],
                Int32_3 = (int)dr["hole2Have"],
                Int32_4 = (int)dr["hole3Need"],
                Int32_5 = (int)dr["hole3Have"],
                Int32_6 = (int)dr["hole4Need"],
                Int32_7 = (int)dr["hole4Have"],
                Int32_8 = (int)dr["hole5Need"],
                Int32_9 = (int)dr["hole5Have"],
                Int32_10 = (int)dr["hole6Need"],
                Int32_11 = (int)dr["hole6Have"]
            };
        }

        public ActiveSystemInfo GetSingleActiveSystem(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_GetSingleActiveSystem", SqlParameters);
                if (ResultDataReader.Read())
                    return this.InitActiveSystemInfo(ResultDataReader);
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_GetSingleActiveSystem", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (ActiveSystemInfo)null;
        }

        public ActiveSystemInfo InitActiveSystemInfo(SqlDataReader dr)
        {
            return new ActiveSystemInfo()
            {
                ID = (int)dr["ID"],
                UserID = (int)dr["UserID"],
                useableScore = (int)dr["useableScore"],
                totalScore = (int)dr["totalScore"],
                AvailTime = (int)dr["AvailTime"],
                NickName = dr["NickName"] == null ? "" : dr["NickName"].ToString(),
                dayScore = (int)dr["dayScore"],
                CanGetGift = (bool)dr["CanGetGift"],
                canOpenCounts = (int)dr["canOpenCounts"],
                canEagleEyeCounts = (int)dr["canEagleEyeCounts"],
                lastFlushTime = (DateTime)dr["lastFlushTime"],
                isShowAll = (bool)dr["isShowAll"],
                ActiveMoney = (int)dr["AvtiveMoney"],
                activityTanabataNum = (int)dr["activityTanabataNum"],
                ChallengeNum = (int)dr["ChallengeNum"],
                BuyBuffNum = (int)dr["BuyBuffNum"],
                lastEnterYearMonter = (DateTime)dr["lastEnterYearMonter"],
                DamageNum = (int)dr["DamageNum"],
                BoxState = dr["BoxState"] == null ? "" : dr["BoxState"].ToString(),
                LuckystarCoins = (int)dr["LuckystarCoins"],
                CryptBoss = dr["CryptBoss"] == null ? "" : dr["CryptBoss"].ToString(),
                Int32_0 = (int)dr["DDPlayPoint"],
                lastEnterWorshiped = (DateTime)dr["lastEnterWorshiped"],
                updateFreeCounts = (int)dr["updateFreeCounts"],
                updateWorshipedCounts = (int)dr["updateWorshipedCounts"],
                update200State = (int)dr["update200State"],
                luckCount = (int)dr["luckCount"],
                remainTimes = (int)dr["remainTimes"],
                LastRefresh = (DateTime)dr["LastRefresh"],
                CurRefreshedTimes = (int)dr["CurRefreshedTimes"],
                EntertamentPoint = (int)dr["EntertamentPoint"],
                ChickActiveData = dr["ChickActiveData"] == null ? "" : dr["ChickActiveData"].ToString()
            };
        }

        public bool AddActiveSystem(ActiveSystemInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[33];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)info.UserID);
                SqlParameters[2] = new SqlParameter("@useableScore", (object)info.useableScore);
                SqlParameters[3] = new SqlParameter("@totalScore", (object)info.totalScore);
                SqlParameters[4] = new SqlParameter("@AvailTime", (object)info.AvailTime);
                SqlParameters[5] = new SqlParameter("@NickName", (object)info.NickName);
                SqlParameters[6] = new SqlParameter("@CanGetGift", (object)info.CanGetGift);
                SqlParameters[7] = new SqlParameter("@canOpenCounts", (object)info.canOpenCounts);
                SqlParameters[8] = new SqlParameter("@canEagleEyeCounts", (object)info.canEagleEyeCounts);
                SqlParameters[9] = new SqlParameter("@lastFlushTime", (object)info.lastFlushTime);
                SqlParameters[10] = new SqlParameter("@isShowAll", (object)info.isShowAll);
                SqlParameters[11] = new SqlParameter("@AvtiveMoney", (object)info.ActiveMoney);
                SqlParameters[12] = new SqlParameter("@activityTanabataNum", (object)info.activityTanabataNum);
                SqlParameters[13] = new SqlParameter("@ChallengeNum", (object)info.ChallengeNum);
                SqlParameters[14] = new SqlParameter("@BuyBuffNum", (object)info.BuyBuffNum);
                SqlParameters[15] = new SqlParameter("@lastEnterYearMonter", (object)info.lastEnterYearMonter);
                SqlParameters[16] = new SqlParameter("@DamageNum", (object)info.DamageNum);
                SqlParameters[17] = new SqlParameter("@BoxState", (object)info.BoxState);
                SqlParameters[18] = new SqlParameter("@LuckystarCoins", (object)info.LuckystarCoins);
                SqlParameters[19] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[19].Direction = ParameterDirection.ReturnValue;
                SqlParameters[20] = new SqlParameter("@CryptBoss", (object)info.CryptBoss);
                SqlParameters[21] = new SqlParameter("@dayScore", (object)info.dayScore);
                SqlParameters[22] = new SqlParameter("@DDPlayPoint", (object)info.Int32_0);
                SqlParameters[23] = new SqlParameter("@lastEnterWorshiped", (object)info.lastEnterWorshiped);
                SqlParameters[24] = new SqlParameter("@updateFreeCounts", (object)info.updateFreeCounts);
                SqlParameters[25] = new SqlParameter("@updateWorshipedCounts", (object)info.updateWorshipedCounts);
                SqlParameters[26] = new SqlParameter("@update200State", (object)info.update200State);
                SqlParameters[27] = new SqlParameter("@luckCount", (object)info.luckCount);
                SqlParameters[28] = new SqlParameter("@remainTimes", (object)info.remainTimes);
                SqlParameters[29] = new SqlParameter("@LastRefresh", (object)info.LastRefresh);
                SqlParameters[30] = new SqlParameter("@CurRefreshedTimes", (object)info.CurRefreshedTimes);
                SqlParameters[31] = new SqlParameter("@EntertamentPoint", (object)info.EntertamentPoint);
                SqlParameters[32] = new SqlParameter("@ChickActiveData", (object)info.ChickActiveData);
                this.db.RunProcedure("SP_ActiveSystem_Add", SqlParameters);
                flag = (int)SqlParameters[19].Value == 0;
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateActiveSystem(ActiveSystemInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[33]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@useableScore", (object) info.useableScore),
          new SqlParameter("@totalScore", (object) info.totalScore),
          new SqlParameter("@AvailTime", (object) info.AvailTime),
          new SqlParameter("@NickName", (object) info.NickName),
          new SqlParameter("@CanGetGift", (object) info.CanGetGift),
          new SqlParameter("@canOpenCounts", (object) info.canOpenCounts),
          new SqlParameter("@canEagleEyeCounts", (object) info.canEagleEyeCounts),
          new SqlParameter("@lastFlushTime", (object) info.lastFlushTime),
          new SqlParameter("@isShowAll", (object) info.isShowAll),
          new SqlParameter("@AvtiveMoney", (object) info.ActiveMoney),
          new SqlParameter("@activityTanabataNum", (object) info.activityTanabataNum),
          new SqlParameter("@ChallengeNum", (object) info.ChallengeNum),
          new SqlParameter("@BuyBuffNum", (object) info.BuyBuffNum),
          new SqlParameter("@lastEnterYearMonter", (object) info.lastEnterYearMonter),
          new SqlParameter("@DamageNum", (object) info.DamageNum),
          new SqlParameter("@BoxState", (object) info.BoxState),
          new SqlParameter("@LuckystarCoins", (object) info.LuckystarCoins),
          new SqlParameter("@Result", SqlDbType.Int),
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null
                };
                SqlParameters[19].Direction = ParameterDirection.ReturnValue;
                SqlParameters[20] = new SqlParameter("@CryptBoss", (object)info.CryptBoss);
                SqlParameters[21] = new SqlParameter("@dayScore", (object)info.dayScore);
                SqlParameters[22] = new SqlParameter("@DDPlayPoint", (object)info.Int32_0);
                SqlParameters[23] = new SqlParameter("@lastEnterWorshiped", (object)info.lastEnterWorshiped);
                SqlParameters[24] = new SqlParameter("@updateFreeCounts", (object)info.updateFreeCounts);
                SqlParameters[25] = new SqlParameter("@updateWorshipedCounts", (object)info.updateWorshipedCounts);
                SqlParameters[26] = new SqlParameter("@update200State", (object)info.update200State);
                SqlParameters[27] = new SqlParameter("@luckCount", (object)info.luckCount);
                SqlParameters[28] = new SqlParameter("@remainTimes", (object)info.remainTimes);
                SqlParameters[29] = new SqlParameter("@LastRefresh", (object)info.LastRefresh);
                SqlParameters[30] = new SqlParameter("@CurRefreshedTimes", (object)info.CurRefreshedTimes);
                SqlParameters[31] = new SqlParameter("@EntertamentPoint", (object)info.EntertamentPoint);
                SqlParameters[32] = new SqlParameter("@ChickActiveData", (object)info.ChickActiveData);
                this.db.RunProcedure("SP_UpdateActiveSystem", SqlParameters);
                flag = (int)SqlParameters[19].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateActiveSystem", ex);
            }
            return flag;
        }

        public LightriddleQuestInfo[] GetAllLightriddleQuestInfo()
        {
            List<LightriddleQuestInfo> lightriddleQuestInfoList = new List<LightriddleQuestInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            int num = 1;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_Lightriddle_Quest_All");
                while (ResultDataReader.Read())
                {
                    lightriddleQuestInfoList.Add(new LightriddleQuestInfo()
                    {
                        QuestionID = (int)ResultDataReader["QuestionID"],
                        QuestionContent = (string)ResultDataReader["QuestionContent"],
                        Option1 = (string)ResultDataReader["Option1"],
                        Option2 = (string)ResultDataReader["Option2"],
                        Option3 = (string)ResultDataReader["Option3"],
                        Option4 = (string)ResultDataReader["Option4"],
                        OptionTrue = (int)ResultDataReader["OptionTrue"]
                    });
                    ++num;
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_Lightriddle_Quest_All", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return lightriddleQuestInfoList.ToArray();
        }

        public UserMatchInfo[] GetAllUserMatchInfo()
        {
            List<UserMatchInfo> userMatchInfoList = new List<UserMatchInfo>();
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            int num = 1;
            try
            {
                this.db.GetReader(ref ResultDataReader, "SP_UserMatch_All_DESC");
                while (ResultDataReader.Read())
                {
                    userMatchInfoList.Add(new UserMatchInfo()
                    {
                        UserID = (int)ResultDataReader["UserID"],
                        totalPrestige = (int)ResultDataReader["totalPrestige"],
                        rank = num
                    });
                    ++num;
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"GetAllUserMatchDESC", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return userMatchInfoList.ToArray();
        }

        public UserMatchInfo GetSingleUserMatchInfo(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_GetSingleUserMatchInfo", SqlParameters);
                if (ResultDataReader.Read())
                    return new UserMatchInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        UserID = (int)ResultDataReader[nameof(UserID)],
                        dailyScore = (int)ResultDataReader["dailyScore"],
                        dailyWinCount = (int)ResultDataReader["dailyWinCount"],
                        dailyGameCount = (int)ResultDataReader["dailyGameCount"],
                        DailyLeagueFirst = (bool)ResultDataReader["DailyLeagueFirst"],
                        DailyLeagueLastScore = (int)ResultDataReader["DailyLeagueLastScore"],
                        weeklyScore = (int)ResultDataReader["weeklyScore"],
                        weeklyGameCount = (int)ResultDataReader["weeklyGameCount"],
                        weeklyRanking = (int)ResultDataReader["weeklyRanking"],
                        addDayPrestge = (int)ResultDataReader["addDayPrestge"],
                        totalPrestige = (int)ResultDataReader["totalPrestige"],
                        restCount = (int)ResultDataReader["restCount"]
                    };
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_GetSingleUserMatchInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return (UserMatchInfo)null;
        }

        public bool AddUserMatchInfo(UserMatchInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[14];
                SqlParameters[0] = new SqlParameter("@ID", (object)info.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)info.UserID);
                SqlParameters[2] = new SqlParameter("@dailyScore", (object)info.dailyScore);
                SqlParameters[3] = new SqlParameter("@dailyWinCount", (object)info.dailyWinCount);
                SqlParameters[4] = new SqlParameter("@dailyGameCount", (object)info.dailyGameCount);
                SqlParameters[5] = new SqlParameter("@DailyLeagueFirst", (object)info.DailyLeagueFirst);
                SqlParameters[6] = new SqlParameter("@DailyLeagueLastScore", (object)info.DailyLeagueLastScore);
                SqlParameters[7] = new SqlParameter("@weeklyScore", (object)info.weeklyScore);
                SqlParameters[8] = new SqlParameter("@weeklyGameCount", (object)info.weeklyGameCount);
                SqlParameters[9] = new SqlParameter("@weeklyRanking", (object)info.weeklyRanking);
                SqlParameters[10] = new SqlParameter("@addDayPrestge", (object)info.addDayPrestge);
                SqlParameters[11] = new SqlParameter("@totalPrestige", (object)info.totalPrestige);
                SqlParameters[12] = new SqlParameter("@restCount", (object)info.restCount);
                SqlParameters[13] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[13].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UserMatch_Add", SqlParameters);
                flag = (int)SqlParameters[13].Value == 0;
                info.ID = (int)SqlParameters[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateUserMatchInfo(UserMatchInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[14]
                {
          new SqlParameter("@ID", (object) info.ID),
          new SqlParameter("@UserID", (object) info.UserID),
          new SqlParameter("@dailyScore", (object) info.dailyScore),
          new SqlParameter("@dailyWinCount", (object) info.dailyWinCount),
          new SqlParameter("@dailyGameCount", (object) info.dailyGameCount),
          new SqlParameter("@DailyLeagueFirst", (object) info.DailyLeagueFirst),
          new SqlParameter("@DailyLeagueLastScore", (object) info.DailyLeagueLastScore),
          new SqlParameter("@weeklyScore", (object) info.weeklyScore),
          new SqlParameter("@weeklyGameCount", (object) info.weeklyGameCount),
          new SqlParameter("@weeklyRanking", (object) info.weeklyRanking),
          new SqlParameter("@addDayPrestge", (object) info.addDayPrestge),
          new SqlParameter("@totalPrestige", (object) info.totalPrestige),
          new SqlParameter("@restCount", (object) info.restCount),
          new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[13].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UpdateUserMatch", SqlParameters);
                flag = (int)SqlParameters[13].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateUserMatch", ex);
            }
            return flag;
        }

        public List<UserRankInfo> GetSingleUserRank(int UserID)
        {
            SqlDataReader ResultDataReader = (SqlDataReader)null;
            List<UserRankInfo> singleUserRank = new List<UserRankInfo>();
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
          new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = (object)UserID;
                this.db.GetReader(ref ResultDataReader, "SP_GetSingleUserRank", SqlParameters);
                while (ResultDataReader.Read())
                    singleUserRank.Add(new UserRankInfo()
                    {
                        ID = (int)ResultDataReader["ID"],
                        UserID = (int)ResultDataReader[nameof(UserID)],
                        Name = (string)ResultDataReader["Name"],
                        Attack = (int)ResultDataReader["Attack"],
                        Defence = (int)ResultDataReader["Defence"],
                        Luck = (int)ResultDataReader["Luck"],
                        Agility = (int)ResultDataReader["Agility"],
                        HP = (int)ResultDataReader["HP"],
                        Damage = (int)ResultDataReader["Damage"],
                        Guard = (int)ResultDataReader["Guard"],
                        BeginDate = (DateTime)ResultDataReader["BeginDate"],
                        Validate = (int)ResultDataReader["Validate"],
                        IsExit = (bool)ResultDataReader["IsExit"],
                        NewTitleID = (int)ResultDataReader["NewTitleID"],
                        EndDate = (DateTime)ResultDataReader["EndDate"]
                    });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_GetSingleUserRankInfo", ex);
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                    ResultDataReader.Close();
            }
            return singleUserRank;
        }

        public bool AddUserRank(UserRankInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[16];
                SqlParameters[0] = new SqlParameter("@ID", (object)item.ID);
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", (object)item.UserID);
                SqlParameters[2] = new SqlParameter("@Name", (object)item.Name);
                SqlParameters[3] = new SqlParameter("@Attack", (object)item.Attack);
                SqlParameters[4] = new SqlParameter("@Defence", (object)item.Defence);
                SqlParameters[5] = new SqlParameter("@Luck", (object)item.Luck);
                SqlParameters[6] = new SqlParameter("@Agility", (object)item.Agility);
                SqlParameters[7] = new SqlParameter("@HP", (object)item.HP);
                SqlParameters[8] = new SqlParameter("@Damage", (object)item.Damage);
                SqlParameters[9] = new SqlParameter("@Guard", (object)item.Guard);
                SqlParameters[10] = new SqlParameter("@BeginDate", (object)item.BeginDate);
                SqlParameters[11] = new SqlParameter("@Validate", (object)item.Validate);
                SqlParameters[12] = new SqlParameter("@IsExit", (object)item.IsExit);
                SqlParameters[13] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[13].Direction = ParameterDirection.ReturnValue;
                SqlParameters[14] = new SqlParameter("@NewTitleID", (object)item.NewTitleID);
                SqlParameters[15] = new SqlParameter("@EndDate", (object)item.EndDate);
                this.db.RunProcedure("SP_UserRank_Add", SqlParameters);
                flag = (int)SqlParameters[13].Value == 0;
                item.ID = (int)SqlParameters[0].Value;
                item.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"Init", ex);
            }
            return flag;
        }

        public bool UpdateUserRank(UserRankInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[16]
                {
          new SqlParameter("@ID", (object) item.ID),
          new SqlParameter("@UserID", (object) item.UserID),
          new SqlParameter("@Name", (object) item.Name),
          new SqlParameter("@Attack", (object) item.Attack),
          new SqlParameter("@Defence", (object) item.Defence),
          new SqlParameter("@Luck", (object) item.Luck),
          new SqlParameter("@Agility", (object) item.Agility),
          new SqlParameter("@HP", (object) item.HP),
          new SqlParameter("@Damage", (object) item.Damage),
          new SqlParameter("@Guard", (object) item.Guard),
          new SqlParameter("@BeginDate", (object) item.BeginDate),
          new SqlParameter("@Validate", (object) item.Validate),
          new SqlParameter("@IsExit", (object) item.IsExit),
          new SqlParameter("@Result", SqlDbType.Int),
          null,
          null
                };
                SqlParameters[13].Direction = ParameterDirection.ReturnValue;
                SqlParameters[14] = new SqlParameter("@NewTitleID", (object)item.NewTitleID);
                SqlParameters[15] = new SqlParameter("@EndDate", (object)item.EndDate);
                this.db.RunProcedure("SP_UpdateUserRank", SqlParameters);
                flag = (int)SqlParameters[13].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                    BaseBussiness.log.Error((object)"SP_UpdateUserRank", ex);
            }
            return flag;
        }

        public ActivitySystemItemInfo[] GetAllActivitySystemItem()
        {
            List<ActivitySystemItemInfo> list = new List<ActivitySystemItemInfo>();
            SqlDataReader ResultDataReader = null;
            try
            {
                db.GetReader(ref ResultDataReader, "SP_ActivitySystemItem_All");
                while (ResultDataReader.Read())
                {
                    ActivitySystemItemInfo activitySystemItemInfo = new ActivitySystemItemInfo();
                    activitySystemItemInfo.ID = (int)ResultDataReader["ID"];
                    activitySystemItemInfo.ActivityType = (int)ResultDataReader["ActivityType"];
                    activitySystemItemInfo.Quality = (int)ResultDataReader["Quality"];
                    activitySystemItemInfo.TemplateID = (int)ResultDataReader["TemplateID"];
                    activitySystemItemInfo.Count = (int)ResultDataReader["Count"];
                    activitySystemItemInfo.ValidDate = (int)ResultDataReader["ValidDate"];
                    activitySystemItemInfo.IsBind = (bool)ResultDataReader["IsBinds"];
                    activitySystemItemInfo.StrengthLevel = (int)ResultDataReader["StrengthenLevel"];
                    activitySystemItemInfo.AttackCompose = (int)ResultDataReader["AttackCompose"];
                    activitySystemItemInfo.DefendCompose = (int)ResultDataReader["DefendCompose"];
                    activitySystemItemInfo.AgilityCompose = (int)ResultDataReader["AgilityCompose"];
                    activitySystemItemInfo.LuckCompose = (int)ResultDataReader["LuckCompose"];
                    activitySystemItemInfo.Random = (int)ResultDataReader["Random"];
                    ActivitySystemItemInfo item = activitySystemItemInfo;
                    list.Add(item);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetAllActivitySystemItem", exception);
                }
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                {
                    ResultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public string GetSingleRandomName(int sex)
        {
            SqlDataReader ResultDataReader = null;
            try
            {
                if (sex > 1)
                {
                    sex = 1;
                }
                SqlParameter[] array = new SqlParameter[1]
                {
                new SqlParameter("@Sex", SqlDbType.Int, 4)
                };
                array[0].Value = sex;
                db.GetReader(ref ResultDataReader, "SP_GetSingle_RandomName", array);
                if (ResultDataReader.Read())
                {
                    return (ResultDataReader["Name"] == null) ? "unknown" : ResultDataReader["Name"].ToString();
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetSingleRandomName", exception);
                }
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                {
                    ResultDataReader.Close();
                }
            }
            return null;
        }
    }
}
