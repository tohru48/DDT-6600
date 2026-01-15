// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.ThirdSimpleKingSecond
// Assembly: GameServerScripts, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null
// MVID: 874FD49D-6008-4657-BF17-33B6C25BB639
// Assembly location: D:\DDTANK\Dosyalar\DDtank_6.5\Emuladores\road\GameServerScripts.dll

using Game.Logic;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using System.Collections.Generic;

#nullable disable
namespace GameServerScript.AI.NPC
{
  public class ThirdSimpleKingSecond : ABrain
  {
    private int m_attackTurn = 0;
    private int npcID = 3006;
    private int npcID2 = 3010;
    private PhysicalObj m_kingMoive;
    private static string[] AllAttackChat = new string[3]
    {
      "Trận động đất, bản thân mình! ! <br/> bạn vui lòng Ay giúp đỡ",
      "Hạ vũ khí xuống!",
      "Xem nếu bạn có thể đủ khả năng, một số ít!！"
    };
    private static string[] CallChat = new string[2]
    {
      "Vệ binh! <br/> bảo vệ! ! ",
      "Boo đệm! ! <br/> cung cấp cho tôi một số trợ giúp!"
    };
    private static string[] ShootChat = new string[3]
    {
      "Nếm thử cái này!",
      "Gửi cho bạn một quả bóng - bạn phải chọn Vâng",
      "Nhóm của bạn của những người dân thường ngu dốt và thấp"
    };
    private static string[] ShootedChat = new string[2]
    {
      "Ah ~ ~ Tại sao bạn tấn công? <br/> tôi đang làm gì?",
      "Oh ~ ~ nó thực sự đau khổ! Tại sao tôi phải chiến đấu? <br/> tôi phải chiến đấu ..."
    };
    private static string[] AddBooldChat = new string[3]
    {
      "Xoắn ah xoay ~ <br/>xoắn ah xoay ~ ~ ~",
      "~ Hallelujah <br/>Luyaluya ~ ~ ~",
      "Yeah Yeah Yeah, <br/> để thoải mái!"
    };
    private static string[] KillAttackChat = new string[1]
    {
      "Con rồng trong thế giới! !"
    };

    public override void OnBeginSelfTurn() => base.OnBeginSelfTurn();

    public override void OnBeginNewTurn()
    {
      base.OnBeginNewTurn();
      this.m_body.CurrentDamagePlus = 1f;
      this.m_body.CurrentShootMinus = 1f;
    }

    public override void OnCreated() => base.OnCreated();

    public override void OnStartAttacking()
    {
      base.OnStartAttacking();
      this.Body.Direction = this.Game.FindlivingbyDir(this.Body);
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 0 && allFightPlayer.X < 300)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(0, 300);
      else if (this.m_attackTurn == 0)
      {
        this.Jump2();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.Star();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 2)
      {
        this.Jump();
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 3)
      {
        this.Summon();
        ++this.m_attackTurn;
      }
      else
      {
        this.Healing();
        this.m_attackTurn = 0;
      }
    }

    private void KillAttack(int fx, int tx)
    {
      this.Body.CurrentDamagePlus = 10f;
      int index = this.Game.Random.Next(0, ThirdSimpleKingSecond.KillAttackChat.Length);
      this.Body.Say(ThirdSimpleKingSecond.KillAttackChat[index], 1, 1000);
      this.Body.PlayMovie("beat", 3000, 0);
      this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
    }

    private void Star()
    {
      this.m_kingMoive = (PhysicalObj) ((PVEGame) this.Game).Createlayer(this.Body.X, this.Body.Y - 10, "moive", "asset.game.4.buff", "out", 1, 1);
      this.Body.CallFuction(new LivingCallBack(this.Remove), 1000);
    }

    public void Remove()
    {
      if (this.m_kingMoive == null)
        return;
      this.Game.RemovePhysicalObj(this.m_kingMoive, true);
      this.m_kingMoive = (PhysicalObj) null;
    }

    private void Jump()
    {
      this.Body.JumpTo(this.Body.X, this.Body.Y - 130, "", 1000, 1, 12, new LivingCallBack(this.NextAttack));
    }

    private void Jump2()
    {
      this.Body.PlayMovie("walk", 100, 1000);
      this.Body.FallFromTo(this.Body.X, this.Body.Y + 130, "", 1000, 0, 25, new LivingCallBack(this.NextAttack));
    }

    public void Healing()
    {
      this.Body.SyncAtTime = true;
      this.Body.AddBlood(5000);
      this.Body.PlayMovie("castA", 100, 0);
      this.Body.Say("Định đánh bại bọn ta à, không dể đâu!", 0, 0);
    }

    private void Summon()
    {
      int index = this.Game.Random.Next(0, ThirdSimpleKingSecond.CallChat.Length);
      this.Body.Say(ThirdSimpleKingSecond.CallChat[index], 0, 3300);
      this.Body.PlayMovie("call", 3500, 0);
      this.Body.CallFuction(new LivingCallBack(this.CreateChild), 4000);
    }

    public void CreateChild()
    {
      ((SimpleBoss) this.Body).CreateChild(this.npcID2, 827, 628, 430, 1, -1);
    }

    private void NextAttack()
    {
      Player randomPlayer = this.Game.FindRandomPlayer();
      this.Body.CurrentDamagePlus = 0.8f;
      int index = this.Game.Random.Next(0, ThirdSimpleKingSecond.ShootChat.Length);
      this.Body.Say(ThirdSimpleKingSecond.ShootChat[index], 0, 0);
      if (randomPlayer == null || !this.Body.ShootPoint(this.Game.Random.Next(randomPlayer.X - 20, randomPlayer.X + 20), randomPlayer.Y, 54, 1000, 10000, 1, 1f, 2300))
        return;
      this.Body.PlayMovie("beatA", 1500, 0);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();
  }
}
