// Decompiled with JetBrains decompiler
// Type: GameServerScript.AI.NPC.DCSM40006Boss
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
  public class DCSM40006Boss : ABrain
  {
    private int m_attackTurn = 0;
    private int m_turn = 0;
    private PhysicalObj m_wallLeft = (PhysicalObj) null;
    private PhysicalObj m_wallRight = (PhysicalObj) null;
    private int IsEixt = 0;
    private int npcID = 1310;
    private static string[] AllAttackChat = new string[3]
    {
      "Trận động đất, bản thân mình! ! <br/> bạn vui lòng Ay giúp đỡ",
      "Hạ vũ khí xuống!",
      "Xem nếu bạn có thể đủ khả năng, một số ít!！"
    };
    private static string[] ShootChat = new string[3]
    {
      "Cho bạn biết những gì một cú sút vết nứt!",
      "Gửi cho bạn một quả bóng - bạn phải chọn Vâng",
      "Nhóm của bạn của những người dân thường ngu dốt và thấp"
    };
    private static string[] ShootedChat = new string[2]
    {
      "Ah ~ ~ Tại sao bạn tấn công? <br/> tôi đang làm gì?",
      "Oh ~ ~ nó thực sự đau khổ! Tại sao tôi phải chiến đấu? <br/> tôi phải chiến đấu ..."
    };
    private static string[] KillPlayerChat = new string[3]
    {
      "Mathias không kiểm soát tôi!",
      "Đây là thách thức số phận của tôi!",
      "Không! !Đây không phải là ý chí của tôi ..."
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
    private static string[] FrostChat = new string[3]
    {
      "Hương vị này",
      "Hãy để bạn bình tĩnh",
      "Bạn đã giận dữ với tôi."
    };
    private static string[] WallChat = new string[2]
    {
      "Chúa, cho tôi sức mạnh!",
      "Tuyệt vọng, xem tường thủy tinh của tôi!"
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
      bool flag = false;
      int num1 = 0;
      foreach (Player allFightPlayer in this.Game.GetAllFightPlayers())
      {
        if (allFightPlayer.IsLiving && allFightPlayer.X > 620 && allFightPlayer.X < 1160)
        {
          int num2 = (int) this.Body.Distance(allFightPlayer.X, allFightPlayer.Y);
          if (num2 > num1)
            num1 = num2;
          flag = true;
        }
      }
      if (flag)
        this.KillAttack(620, 1160);
      else if (this.m_attackTurn == 0)
      {
        this.AllAttack();
        if (this.IsEixt == 1)
        {
          this.m_wallLeft.CanPenetrate = true;
          this.m_wallRight.CanPenetrate = true;
          this.Game.RemovePhysicalObj(this.m_wallLeft, true);
          this.Game.RemovePhysicalObj(this.m_wallRight, true);
          this.IsEixt = 0;
        }
        ++this.m_attackTurn;
      }
      else if (this.m_attackTurn == 1)
      {
        this.ProtectingWall();
        ++this.m_attackTurn;
      }
      else
      {
        this.CallBaby();
        this.m_attackTurn = 0;
      }
    }

    private void CallBaby()
    {
      this.Body.PlayMovie("renew", 3500, 0);
      this.Body.CallFuction(new LivingCallBack(this.CreateChild), 6000);
    }

    private void AllAttack()
    {
      this.Body.CurrentDamagePlus = 0.5f;
      if (this.m_turn == 0)
      {
        int index = this.Game.Random.Next(0, DCSM40006Boss.AllAttackChat.Length);
        this.Body.Say(DCSM40006Boss.AllAttackChat[index], 1, 13000);
        this.Body.PlayMovie("beat1", 15000, 0);
        this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 17000, (List<Player>) null);
        ++this.m_turn;
      }
      else
      {
        int index = this.Game.Random.Next(0, DCSM40006Boss.AllAttackChat.Length);
        this.Body.Say(DCSM40006Boss.AllAttackChat[index], 1, 0);
        this.Body.PlayMovie("beat1", 1000, 0);
        this.Body.RangeAttacking(this.Body.X - 1000, this.Body.X + 1000, "cry", 3000, (List<Player>) null);
      }
    }

    private void KillAttack(int fx, int tx)
    {
      int index = this.Game.Random.Next(0, DCSM40006Boss.KillAttackChat.Length);
      if (this.m_turn == 0)
      {
        this.Body.CurrentDamagePlus = 10f;
        this.Body.Say(DCSM40006Boss.KillAttackChat[index], 1, 13000);
        this.Body.PlayMovie("beat1", 15000, 0);
        this.Body.RangeAttacking(fx, tx, "cry", 17000, (List<Player>) null);
        ++this.m_turn;
      }
      else
      {
        this.Body.CurrentDamagePlus = 10f;
        this.Body.Say(DCSM40006Boss.KillAttackChat[index], 1, 0);
        this.Body.PlayMovie("beat1", 2000, 0);
        this.Body.RangeAttacking(fx, tx, "cry", 4000, (List<Player>) null);
      }
    }

    private void ProtectingWall()
    {
      if (this.IsEixt == 0)
      {
        this.m_wallLeft = ((PVEGame) this.Game).CreatePhysicalObj(this.Body.X - 65, 620, "wallLeft", "com.mapobject.asset.WaveAsset_01_left", "1", 1, 0);
        this.m_wallRight = ((PVEGame) this.Game).CreatePhysicalObj(this.Body.X + 65, 620, "wallLeft", "com.mapobject.asset.WaveAsset_01_right", "1", 1, 0);
        this.m_wallLeft.SetRect(-165, -169, 43, 330);
        this.m_wallRight.SetRect(128, -165, 41, 330);
        this.IsEixt = 1;
      }
      int index = this.Game.Random.Next(0, DCSM40006Boss.WallChat.Length);
      this.Body.Say(DCSM40006Boss.WallChat[index], 1, 0);
    }

    public void CreateChild()
    {
      this.Body.PlayMovie("renew", 100, 2000);
      ((SimpleBoss) this.Body).CreateChild(this.npcID, 520, 530, 400, 6, -1);
    }

    public override void OnStopAttacking() => base.OnStopAttacking();
  }
}
