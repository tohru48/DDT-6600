// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirdNormalFixureLongNpc
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Bussiness;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class ThirdNormalFixureLongNpc : ABrain
  {
    private int m_attackTurn = 0;
    private int isSay = 0;
    private static string[] AllAttackChat = new string[1]
    {
      LanguageMgr.GetTranslation("Ddtank Vn là số 1")
    };
    private static string[] ShootChat = new string[1]
    {
      LanguageMgr.GetTranslation("Anh em tiến lên !")
    };
    private static string[] KillPlayerChat = new string[1]
    {
      LanguageMgr.GetTranslation("Anh em tiến lên !")
    };
    private static string[] CallChat = new string[1]
    {
      LanguageMgr.GetTranslation("Ai giết được chúng sẻ được ban thưởng !")
    };
    private static string[] JumpChat = new string[1]
    {
      LanguageMgr.GetTranslation("Ai giết được chúng sẻ được ban thưởng !")
    };
    private static string[] KillAttackChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg13"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg14")
    };
    private static string[] ShootedChat = new string[2]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg15"),
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg16")
    };
    private static string[] DiedChat = new string[1]
    {
      LanguageMgr.GetTranslation("GameServerScript.AI.NPC.SimpleQueenAntAi.msg17")
    };
    private static Random random = new Random();
    private static string[] listChat = new string[13]
    {
      "Để tôn vinh! Để giành chiến thắng! !",
      "Tổ chức cướp vũ khí của họ, không run sợ!",
      "Super Ddtank muôn năm !",
      "Kẻ thù ở phía trước, sẵn sàng chiến đấu!",
      "Cảm thấy hành vi của nhà vua và bất thường hơn ...",
      "Để Boo Goo chiến thắng! ! Brothers phí!",
      "Nhanh chóng để tiêu diệt kẻ thù!",
      "Sức mạnh số 1 !",
      "Với một sửa chữa nhanh chóng!",
      "Vây quanh kẻ thù và tiêu diệt chúng.",
      "Quân tiếp viện! Quân tiếp viện! Chúng tôi cần thêm quân tiếp viện! !",
      "Hy sinh bản thân, sẽ không cho phép bạn có được đi với.",
      "Đừng đánh giá thấp sức mạnh của Boo Goo, nếu không bạn sẽ phải trả cho việc này."
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.Body.CurrentDamagePlus = 1f;
      this.Body.CurrentShootMinus = 1f;
      this.isSay = 0;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 0 && allFightPlayer.X < 0)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(0, 0);
      else if (this.m_attackTurn == 0)
      {
        if (this.Game.GetLivedLivings().Count == 9)
          this.PersonalAttack();
        else
          this.PersonalAttack();
        ++this.m_attackTurn;
      }
      else
      {
        this.PersonalAttack();
        this.m_attackTurn = 0;
      }
    }

    public override void OnStopAttacking() => base.OnStopAttacking();

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, ThirdNormalFixureLongNpc.KillAttackChat.Length);
      this.Body.Say(ThirdNormalFixureLongNpc.KillAttackChat[index], 1, 1000);
      this.Body.CurrentDamagePlus = 10f;
      this.Body.PlayMovie("beatB", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 5000, (List<Player>) null);
    }

    private void PersonalAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      if (randomPlayer == null)
        return;
      this.Body.CurrentDamagePlus = 0.8f;
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      this.Game.Random.Next(randomPlayer.X, randomPlayer.X);
      if (this.Body.ShootPoint(randomPlayer.X, randomPlayer.Y, 58, 1000, 10000, 1, 3f, 2550))
        this.Body.PlayMovie("beatA", 1700, 0);
    }

    public override void OnKillPlayerSay()
    {
      base.OnKillPlayerSay();
      int index = this.Game.Random.Next(0, ThirdNormalFixureLongNpc.KillPlayerChat.Length);
      this.Body.Say(ThirdNormalFixureLongNpc.KillPlayerChat[index], 1, 0, 2000);
    }

    public override void OnDiedSay()
    {
    }

    private void CreateChild()
    {
    }

    public override void OnShootedSay()
    {
      int index1 = this.Game.Random.Next(0, ThirdNormalFixureLongNpc.ShootedChat.Length);
      if (this.isSay == 0 && this.Body.IsLiving)
      {
        this.Body.Say(ThirdNormalFixureLongNpc.ShootedChat[index1], 1, 900, 0);
        this.isSay = 1;
      }
      if (this.Body.IsLiving)
        return;
      int index2 = this.Game.Random.Next(0, ThirdNormalFixureLongNpc.DiedChat.Length);
      this.Body.Say(ThirdNormalFixureLongNpc.DiedChat[index2], 1, 100, 2000);
    }

    public static string GetOneChat()
    {
      int index = ThirdNormalFixureLongNpc.random.Next(0, ThirdNormalFixureLongNpc.listChat.Length);
      return ThirdNormalFixureLongNpc.listChat[index];
    }

    public static void LivingSay(List<Living> livings)
    {
      if (livings == null || livings.Count == 0)
        return;
      int count = livings.Count;
      foreach (Living living in livings)
        living.IsSay = false;
      int length = count > 5 ? (count <= 5 || count > 10 ? ThirdNormalFixureLongNpc.random.Next(1, 4) : ThirdNormalFixureLongNpc.random.Next(1, 3)) : ThirdNormalFixureLongNpc.random.Next(0, 2);
      if (length <= 0)
        return;
      int[] numArray = new int[length];
      int num = 0;
      while (num < length)
      {
        int index = ThirdNormalFixureLongNpc.random.Next(0, count);
        if (!livings[index].IsSay)
        {
          livings[index].IsSay = true;
          int delay = ThirdNormalFixureLongNpc.random.Next(0, 5000);
          livings[index].Say(ThirdNormalFixureLongNpc.GetOneChat(), 0, delay);
          ++num;
        }
      }
    }
  }
}
