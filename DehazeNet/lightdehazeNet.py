# @author: hayat
import torch
import torch.nn as nn
import math
import numpy as np


class SE_Block(nn.Module):
    def __init__(self, ch_in, reduction=16):
        super(SE_Block, self).__init__()
        self.avg_pool = nn.AdaptiveAvgPool2d(1)  # 全局⾃适应池化
        self.fc = nn.Sequential(
            nn.Linear(ch_in, ch_in // reduction, bias=False),
            nn.ReLU(inplace=True),
            nn.Linear(ch_in // reduction, ch_in, bias=False),
            nn.Sigmoid()
        )
    def forward(self, x):
        b, c, _, _ = x.size()
        y = self.avg_pool(x).view(b, c) # squeeze操作
        y = self.fc(y).view(b, c, 1, 1) # FC获取通道注意⼒权重，是具有全局信息的
        return x * y.expand_as(x) # 注意⼒作⽤每⼀个通道上


class Msd_Layer(nn.Module):
    def __init__(self):
        super(Msd_Layer,self).__init__()

        self.relu = nn.ReLU(inplace=True)


        self.o_1_conv_layer = nn.Conv2d(16,16,1,1,0,bias=True)
        self.T1_conv_layer = nn.Conv2d(16, 16, 3, 1, 1, bias=True)
        self.F1_conv_layer = nn.Conv2d(16, 16, 5, 1, 2, bias=True)
        self.S1_conv_layer = nn.Conv2d(16, 16, 7, 1, 3, bias=True)

        self.F2_conv_layer = nn.Conv2d(64, 48, 5, 1, 2, bias=True)
        self.T2_conv_layer = nn.Conv2d(64, 48, 3, 1, 1, bias=True)
        self.S2_conv_layer = nn.Conv2d(64, 48, 7, 1, 3, bias=True)

        self.Xn_conv_layer = nn.Conv2d(176, 16, 1, 1, 0)


    def forward(self,X_n_1):
        o_1 = self.o_1_conv_layer(X_n_1)
        T1 = self.relu(self.T1_conv_layer(X_n_1))
        F1 = self.relu(self.F1_conv_layer(X_n_1))
        S1 = self.relu(self.S1_conv_layer(X_n_1))
        contact_layer1 = torch.cat([X_n_1, F1, T1, S1],1)


        F2 = self.relu(self.F2_conv_layer(contact_layer1))
        T2 = self.relu(self.T2_conv_layer(contact_layer1))
        S2 = self.relu(self.S2_conv_layer(contact_layer1))
        contact_layer2 = torch.cat([X_n_1, F2, T2, S2, o_1],1)

        X_n = self.relu(self.Xn_conv_layer(contact_layer2))


        return X_n

class LightDehaze_Net(nn.Module):

    def __init__(self):
        super(LightDehaze_Net, self).__init__()

        # LightDehazeNet Architecture
        self.relu = nn.ReLU(inplace=True)
        # self.relu = torch.nn.functional.relu(inplace = True)

        self.e_conv_layer1 = nn.Conv2d(3,8,1,1,0,bias=True)
        self.e_conv_layer2 = nn.Conv2d(8,8,3,1,1,bias=True)
        self.e_conv_layer3 = nn.Conv2d(8,8,5,1,2,bias=True)
        self.e_conv_layer4 = nn.Conv2d(16,16,7,1,3,bias=True)
        self.e_conv_layer5 = nn.Conv2d(16,16,3,1,1,bias=True)
        self.e_conv_layer6 = nn.Conv2d(16,16,3,1,1,bias=True)
        self.e_conv_layer7 = nn.Conv2d(32,32,3,1,1,bias=True)
        self.e_conv_layer8 = nn.Conv2d(56,3,3,1,1,bias=True)
        self.msd_obj = Msd_Layer()
    #
    # def msd_layer(self,X_n_1):
    #     # Location 1
    #     o_1_conv_layer = nn.Conv2d(16,16,1,1,0,bias=True)
    #     T1_conv_layer = nn.Conv2d(16,16,3,1,1,bias=True)
    #     F1_conv_layer = nn.Conv2d(16,16,5,1,2,bias=True)
    #     S1_conv_layer = nn.Conv2d(16,16,7,1,3,bias=True)
    #     o_1 = o_1_conv_layer(X_n_1)
    #     T1 = self.relu(T1_conv_layer(X_n_1))
    #     F1 = self.relu(F1_conv_layer(X_n_1))
    #     S1 = self.relu(S1_conv_layer(X_n_1))
    #     contact_layer1 = np.concatenate(X_n_1,F1,T1,S1)
    #
    #     # Location 2
    #     F2_conv_layer = nn.Conv2d(48,48,5,1,2,bias=True)
    #     T2_conv_layer = nn.Conv2d(48,48,3,1,1,bias=True)
    #     S2_conv_layer = nn.Conv2d(48,48,7,1,3,bias=True)
    #     F2 = self.relu(F2_conv_layer(contact_layer1))
    #     T2 = self.relu(T2_conv_layer(contact_layer1))
    #     S2 = self.relu(S2_conv_layer(contact_layer1))
    #     contact_layer2 = np.concatenate(X_n_1,F2,T2,S2,o_1) # 16+48+48+48+16 = 176
    #
    #     # Location 3
    #     Xn_conv_layer = nn.Conv2d(176,16,1,1,0)
    #     X_n = self.relu(Xn_conv_layer(contact_layer2))
    #
    #     return X_n





    def forward(self, img):
        pipeline = []
        pipeline.append(img)

        conv_layer1 = self.relu(self.e_conv_layer1(img))
        conv_layer2 = self.relu(self.e_conv_layer2(conv_layer1))
        conv_layer3 = self.relu(self.e_conv_layer3(conv_layer2))

        # concatenating conv1 and conv3
        concat_layer1 = torch.cat((conv_layer1,conv_layer3), 1)

        conv_layer4 = self.relu(self.e_conv_layer4(concat_layer1))
        # insert msd_layer between lay4 & 5
        msd_layer1 = self.msd_obj.forward(conv_layer4)
        conv_layer5 = self.relu(self.e_conv_layer5(msd_layer1))
        conv_layer6 = self.relu(self.e_conv_layer6(conv_layer5))


        # concatenating conv4 and conv6
        concat_layer2 = torch.cat((conv_layer4, conv_layer6), 1)

        conv_layer7= self.relu(self.e_conv_layer7(concat_layer2))

        # concatenating conv2, conv5, and conv7
        concat_layer3 = torch.cat((conv_layer2,conv_layer5,conv_layer7),1)

        conv_layer8 = self.relu(self.e_conv_layer8(concat_layer3))


        dehaze_image = self.relu((conv_layer8 * img) - conv_layer8 + 1)
        #J(x) = clean_image, k(x) = x8, I(x) = x, b = 1


        return dehaze_image



















