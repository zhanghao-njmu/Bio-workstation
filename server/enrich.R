dat_enrich <- reactiveValues()
dat_enrich$input <- NULL
dat_enrich$universe <- NULL
dat_enrich$field_enrich <- 1
dat_enrich$field_enrich2 <- 1
res_enrich <- reactiveValues()
plotList_enrich <- reactiveValues()

observeEvent(input$example_enrich,{
  updateTextAreaInput(session,inputId = "textArea_enrich",value ="11426\n11426\n11429\n11434\n11451\n11459\n11461\n11470\n11471\n11518\n11544\n11545\n11634\n11640\n11642\n11643\n11671\n11674\n11692\n11739\n11744\n11767\n11771\n11792\n11792\n11800\n11834\n11835\n11840\n11841\n11843\n11938\n11946\n11947\n11991\n11991\n12009\n12017\n12033\n12181\n12192\n12215\n12237\n12301\n12301\n12316\n12317\n12330\n12331\n12345\n12345\n12388\n12421\n12454\n12461\n12462\n12462\n12464\n12465\n12466\n12468\n12469\n12537\n12539\n12607\n12617\n12696\n12745\n12785\n12785\n12831\n12832\n12834\n12847\n12877\n12877\n12896\n12934\n12974\n13006\n13043\n13046\n13046\n13135\n13164\n13202\n13204\n13204\n13205\n13206\n13207\n13209\n13211\n13211\n13360\n13417\n13424\n13430\n13433\n13437\n13494\n13518\n13589\n13627\n13629\n13664\n13665\n13669\n13681\n13682\n13684\n13684\n13690\n13722\n13806\n13836\n13872\n13877\n13984\n13992\n14000\n14007\n14007\n14030\n14104\n14105\n14109\n14113\n14118\n14119\n14208\n14225\n14228\n14232\n14265\n14268\n14300\n14359\n14359\n14376\n14433\n14625\n14645\n14651\n14670\n14694\n14705\n14768\n14791\n14792\n14827\n14828\n14852\n14862\n14863\n14866\n14897\n14897\n14897\n14904\n14911\n14911\n14950\n14957\n14958\n15078\n15078\n15185\n15192\n15254\n15289\n15331\n15354\n15354\n15360\n15366\n15369\n15374\n15381\n15382\n15384\n15387\n15388\n15441\n15469\n15469\n15481\n15481\n15504\n15510\n15512\n15516\n15519\n15526\n15547\n15568\n15569\n15571\n15571\n15572\n15572\n15572\n16004\n16170\n16201\n16211\n16319\n16341\n16549\n16554\n16561\n16562\n16563\n16563\n16647\n16648\n16649\n16665\n16709\n16709\n16773\n16785\n16800\n16828\n16833\n16882\n16898\n16906\n16970\n17089\n17149\n17184\n17215\n17220\n17235\n17252\n17281\n17345\n17354\n17454\n17688\n17690\n17755\n17758\n17758\n17827\n17827\n17847\n17876\n17876\n17904\n17921\n17938\n17955\n17975\n17999\n18004\n18107\n18108\n18114\n18139\n18140\n18148\n18148\n18150\n18221\n18286\n18286\n18293\n18415\n18432\n18458\n18459\n18477\n18521\n18521\n18536\n18537\n18541\n18569\n18571\n18572\n18598\n18645\n18663\n18674\n18744\n18746\n18810\n18813\n18949\n18971\n19035\n19046\n19047\n19120\n19134\n19181\n19184\n19205\n19205\n19205\n19241\n19285\n19290\n19291\n19317\n19326\n19383\n19384\n19386\n19387\n19647\n19647\n19652\n19654\n19655\n19656\n19663\n19687\n19704\n19826\n19896\n19899\n19921\n19933\n19934\n19935\n19941\n19941\n19942\n19943\n19946\n19951\n19981\n19988\n19989\n20005\n20014\n20020\n20024\n20044\n20054\n20054\n20055\n20088\n20091\n20102\n20103\n20104\n20116\n20218\n20222\n20224\n20227\n20239\n20257\n20286\n20382\n20383\n20384\n20402\n20408\n20462\n20462\n20492\n20527\n20610\n20624\n20624\n20630\n20637\n20639\n20641\n20643\n20658\n20719\n20742\n20744\n20744\n20815\n20817\n20823\n20826\n20849\n20853\n20853\n20867\n20878\n20901\n20916\n20924\n20926\n20935\n21346\n21357\n21379\n21400\n21402\n21429\n21454\n21454\n21463\n21647\n21672\n21681\n21681\n21689\n21744\n21761\n21762\n21780\n21841\n21843\n21848\n21849\n21872\n21884\n21894\n21917\n21959\n21969\n21973\n21976\n21991\n22019\n22027\n22092\n22099\n22116\n22121\n22122\n22130\n22137\n22138\n22146\n22147\n22154\n22166\n22185\n22192\n22195\n22201\n22224\n22240\n22258\n22272\n22284\n22319\n22321\n22330\n22334\n22335\n22352\n22352\n22367\n22384\n22384\n22385\n22431\n22594\n22608\n22630\n22631\n22668\n22668\n22668\n22680\n22680\n22698\n22763\n22791\n22793\n23856\n23874\n23879\n23881\n23881\n23918\n23955\n23980\n23983\n23992\n23997\n24010\n24067\n24084\n24127\n24128\n26413\n26430\n26451\n26900\n26914\n26914\n26919\n26936\n26961\n27041\n27050\n27176\n27207\n27224\n27225\n27367\n27368\n27370\n27395\n27397\n27398\n27407\n27419\n27632\n27756\n27966\n27967\n27973\n27993\n28036\n28088\n28105\n28114\n28126\n29813\n29819\n29819\n29870\n30054\n30054\n30794\n30795\n30877\n30946\n30959\n30960\n50529\n50708\n50709\n50783\n50783\n50796\n50907\n50911\n50912\n50926\n50926\n50927\n50995\n51786\n51792\n51796\n51810\n51810\n51869\n51886\n51938\n51944\n51960\n52009\n52033\n52040\n52202\n52357\n52477\n52513\n52521\n52530\n52575\n52705\n52837\n52874\n53317\n53319\n53356\n53357\n53379\n53381\n53414\n53416\n53421\n53422\n53422\n53424\n53604\n53607\n53610\n53621\n53621\n53761\n53817\n53857\n53861\n53872\n53975\n54127\n54137\n54138\n54188\n54194\n54196\n54196\n54208\n54214\n54217\n54364\n54367\n54388\n54484\n54673\n55944\n55980\n55989\n56009\n56012\n56031\n56041\n56070\n56088\n56095\n56190\n56191\n56194\n56195\n56200\n56215\n56226\n56258\n56275\n56278\n56280\n56284\n56307\n56307\n56321\n56347\n56350\n56351\n56354\n56372\n56381\n56399\n56403\n56403\n56403\n56403\n56412\n56417\n56421\n56422\n56428\n56430\n56445\n56449\n56449\n56451\n56455\n56459\n56463\n56505\n56516\n56516\n56531\n56535\n56541\n56702\n56734\n56758\n56878\n56878\n57261\n57294\n57312\n57315\n57317\n57432\n57741\n57741\n57746\n57749\n57753\n57756\n57808\n57815\n57837\n57908\n58184\n58233\n58996\n59004\n59013\n59014\n59021\n59022\n59047\n59050\n59054\n59069\n59093\n60321\n60365\n63986\n64059\n64656\n64934\n65019\n65961\n66055\n66070\n66074\n66077\n66146\n66163\n66181\n66184\n66185\n66204\n66212\n66229\n66235\n66242\n66244\n66244\n66245\n66251\n66254\n66273\n66276\n66282\n66354\n66356\n66357\n66367\n66368\n66373\n66384\n66388\n66395\n66407\n66409\n66419\n66421\n66475\n66477\n66483\n66489\n66511\n66514\n66515\n66523\n66538\n66540\n66556\n66580\n66587\n66587\n66589\n66590\n66612\n66645\n66656\n66660\n66661\n66679\n66691\n66704\n66707\n66711\n66716\n66720\n66745\n66756\n66756\n66768\n66810\n66855\n66861\n66870\n66870\n66874\n66877\n66882\n66890\n66899\n66899\n66899\n66904\n66911\n66921\n66938\n66942\n67010\n67014\n67027\n67036\n67039\n67040\n67052\n67054\n67070\n67097\n67115\n67134\n67145\n67148\n67151\n67154\n67157\n67160\n67178\n67197\n67198\n67204\n67205\n67222\n67225\n67225\n67239\n67239\n67241\n67276\n67281\n67291\n67298\n67300\n67302\n67337\n67344\n67384\n67390\n67398\n67416\n67418\n67427\n67437\n67439\n67459\n67465\n67487\n67490\n67493\n67509\n67543\n67544\n67564\n67574\n67579\n67652\n67678\n67684\n67689\n67722\n67724\n67752\n67776\n67781\n67803\n67812\n67832\n67840\n67842\n67878\n67891\n67897\n67898\n67917\n67920\n67922\n67926\n67941\n67946\n67949\n67955\n67958\n67959\n67959\n67973\n67996\n68028\n68035\n68045\n68046\n68052\n68077\n68083\n68092\n68114\n68134\n68134\n68135\n68147\n68172\n68188\n68193\n68215\n68219\n68222\n68223\n68231\n68236\n68263\n68270\n68272\n68275\n68276\n68278\n68292\n68379\n68436\n68475\n68479\n68537\n68549\n68564\n68565\n68592\n68598\n68611\n68693\n68737\n68743\n68796\n68879\n68926\n68966\n68979\n68981\n68988\n69019\n69038\n69072\n69082\n69116\n69163\n69237\n69297\n69317\n69372\n69389\n69397\n69562\n69663\n69823\n69823\n69878\n69902\n69926\n69956\n69982\n70012\n70069\n70078\n70099\n70120\n70248\n70285\n70294\n70312\n70354\n70356\n70426\n70439\n70466\n70572\n70579\n70616\n70617\n70650\n70675\n70683\n70699\n70767\n70769\n70772\n70804\n70925\n70930\n70999\n71088\n71137\n71175\n71242\n71472\n71514\n71564\n71702\n71713\n71735\n71750\n71766\n71770\n71780\n71787\n71799\n71810\n71820\n71835\n71836\n71840\n71853\n71902\n71918\n71970\n71973\n71989\n71990\n71994\n72007\n72047\n72068\n72162\n72181\n72193\n72198\n72322\n72344\n72397\n72416\n72462\n72515\n72554\n72567\n72572\n72584\n72584\n72634\n72634\n72640\n72692\n72722\n72736\n72831\n72831\n72946\n73075\n73139\n73158\n73212\n73333\n73376\n73668\n73668\n73674\n73736\n73779\n73804\n73826\n73833\n73845\n73945\n74006\n74019\n74022\n74035\n74052\n74068\n74075\n74107\n74107\n74111\n74154\n74164\n74174\n74203\n74203\n74213\n74268\n74320\n74326\n74355\n74383\n74470\n74480\n74484\n74600\n74682\n74691\n74716\n74737\n74778\n74838\n74838\n74914\n75050\n75062\n75064\n75137\n75140\n75210\n75210\n75273\n75388\n75388\n75416\n75420\n75439\n75469\n75495\n75507\n75553\n75553\n75617\n75619\n75622\n75623\n75646\n75705\n75732\n75751\n75773\n75785\n75786\n75826\n75829\n75956\n76014\n76183\n76302\n76383\n76386\n76389\n76400\n76479\n76483\n76522\n76572\n76577\n76614\n76626\n76626\n76707\n76737\n76740\n76742\n76800\n76808\n76846\n76850\n76936\n76936\n76938\n77134\n77286\n77485\n77485\n77485\n77591\n77595\n77604\n77605\n77627\n77721\n77963\n77987\n78217\n78244\n78283\n78394\n78428\n78428\n78455\n78455\n78482\n78523\n78581\n78651\n78655\n78656\n78697\n78781\n78781\n78798\n78829\n78893\n78913\n79455\n79456\n80287\n80744\n80838\n80861\n80886\n80912\n80913\n80913\n80986\n81702\n81702\n81896\n81898\n81910\n83397\n83410\n83454\n83456\n83456\n83486\n83557\n83558\n83560\n83561\n83564\n83669\n83701\n93686\n93686\n93687\n93730\n93762\n93765\n94040\n94061\n94062\n94062\n94184\n94213\n94244\n94244\n94275\n94315\n97165\n97212\n97827\n98238\n98386\n98558\n98685\n98733\n98733\n98758\n98956\n98999\n99167\n99480\n100019\n100019\n100121\n100226\n100609\n100637\n100683\n100705\n100978\n101214\n101706\n101739\n101867\n101943\n102060\n102414\n102462\n103135\n103284\n103406\n103573\n103677\n103694\n103963\n104263\n104318\n104318\n104458\n104662\n104721\n104884\n105083\n105203\n105372\n105559\n105689\n105847\n105988\n106143\n106205\n106557\n106583\n106633\n106794\n107094\n107182\n107242\n107271\n107338\n107476\n107508\n107701\n107702\n107733\n107747\n107815\n107815\n107868\n107951\n107970\n108013\n108014\n108037\n108062\n108062\n108121\n108837\n108857\n108857\n108907\n108907\n108911\n108943\n108989\n108989\n109093\n109095\n109181\n109229\n109232\n109658\n109754\n110084\n110109\n110198\n110350\n110611\n110750\n110809\n110816\n110854\n110911\n110911\n110954\n110957\n114584\n114602\n114641\n114642\n114741\n116848\n140486\n140488\n140557\n140740\n170676\n170759\n170791\n170791\n170930\n171170\n192119\n192159\n192160\n192170\n192176\n192196\n192196\n195434\n207214\n207304\n207375\n207607\n207920\n207920\n207932\n208144\n208606\n208718\n208922\n209003\n209012\n210126\n210145\n210510\n211007\n211484\n212124\n212427\n212547\n212880\n212999\n213081\n213109\n213236\n213272\n213484\n213541\n213753\n213773\n213895\n213988\n214048\n214105\n214137\n214290\n214575\n214575\n214627\n214987\n215193\n215194\n215456\n216151\n216156\n216197\n216238\n216345\n216443\n216618\n216766\n216767\n216963\n216987\n217039\n217069\n217109\n217116\n217207\n217331\n217337\n217351\n217431\n217578\n217869\n217980\n217980\n217995\n218232\n218236\n218490\n218490\n218506\n218629\n218693\n218850\n218850\n219158\n219249\n219249\n223499\n223691\n223722\n223828\n223989\n223989\n223989\n224019\n224092\n224139\n224170\n224273\n224344\n224432\n224613\n224727\n224742\n224823\n224902\n224903\n224907\n225027\n225027\n225348\n225363\n225432\n225432\n225913\n225929\n226026\n226412\n226413\n226517\n226551\n226562\n226982\n227331\n227331\n227613\n227656\n227674\n227682\n227695\n227723\n228005\n228410\n228421\n228869\n228869\n228889\n228994\n229003\n229096\n229279\n229279\n229317\n229363\n229504\n229524\n229663\n229675\n229700\n229906\n230082\n230233\n230249\n230257\n230257\n230594\n230596\n230721\n230721\n230734\n230737\n230753\n230861\n230861\n230908\n230908\n230908\n231086\n231207\n231329\n231386\n231386\n231386\n231413\n231452\n231659\n231712\n231713\n231803\n231858\n232217\n232341\n232341\n232560\n232664\n232798\n232973\n232989\n233020\n233020\n233033\n233064\n233208\n233406\n233726\n233789\n233833\n233871\n233908\n234373\n234374\n234388\n234594\n234594\n234699\n234733\n234964\n235036\n235043\n235315\n235339\n235626\n236539\n236732\n236732\n237107\n237336\n237397\n237400\n237400\n237730\n237943\n238217\n238662\n238663\n238799\n239319\n239364\n239435\n239528\n239731\n240087\n240255\n240396\n241490\n241516\n241624\n241846\n241846\n241989\n243272\n243529\n243771\n243846\n243846\n243897\n244216\n244551\n244666\n244672\n244891\n245474\n245566\n245877\n245945\n252870\n267019\n267019\n268373\n268420\n268449\n268491\n268491\n269061\n269209\n269224\n269254\n269254\n269261\n269401\n269470\n269523\n269536\n269639\n270106\n270163\n270192\n270906\n271564\n276770\n277154\n277250\n277353\n278087\n279499\n319195\n319278\n319322\n319448\n319565\n319765\n319765\n319817\n319944\n320165\n320204\n320267\n320267\n320267\n320267\n320429\n320473\n320558\n320632\n320752\n320827\n320938\n326622\n327954\n327992\n328825\n329207\n329251\n329972\n330010\n330149\n330474\n338359\n338366\n338467\n353188\n353190\n360013\n378430\n380669\n380669\n380773\n380994\n381290\n381305\n381476\n381626\n381695\n381760\n381917\n382038\n384309\n384569\n403180\n404634\n407788\n408058\n432467\n432508\n432552\n433470\n433702\n433864\n434768\n434866\n434903\n442829\n545683\n545975\n574428\n619605\n623046\n625193\n627049\n631784\n633285\n633285\n635169\n636931\n664817\n665775\n666420\n666528\n666609\n667618\n668559\n668880\n671232\n672511\n100034361\n100034727\n100037282\n100038538\n108169028")
  updateSelectInput(session,inputId="species_enrich",selected = "Mouse")
  updateSelectInput(session,inputId="idtype_enrich",selected = "ENTREZID")
})

observeEvent(input$use_id_input_enrich, {
  if(input$use_id_input_enrich == F){
    shinyjs::enable("input_enrich")
    shinyjs::enable("fileheader_enrich")
    shinyjs::enable("filesep_enrich")
    shinyjs::enable("fileInput_enrich")
    shinyjs::enable("field_enrich")
    shinyjs::enable("example_enrich")
    shinyjs::enable("textArea_enrich")
  }else{
    shinyjs::disable("input_enrich")
    shinyjs::disable("fileheader_enrich")
    shinyjs::disable("filesep_enrich")
    shinyjs::disable("fileInput_enrich")
    shinyjs::disable("field_enrich")
    shinyjs::disable("example_enrich")
    shinyjs::disable("textArea_enrich")
  }
})

observeEvent(input$simgo_enrich, {
  if(input$simgo_enrich == T){
    shinyjs::enable("simgoby_enrich")
    shinyjs::enable("simgomet_enrich")
    shinyjs::enable("simgo_enrich_cut")
  }else{
    shinyjs::disable("simgoby_enrich")
    shinyjs::disable("simgomet_enrich")
    shinyjs::disable("simgo_enrich_cut")
  }
})

shinyjs::disable("simmesh_enrich")
observeEvent(input$simmesh_enrich, {
  if(input$simmesh_enrich == T){
    shinyjs::enable("simmeshby_enrich")
    shinyjs::enable("simmeshmet_enrich")
    shinyjs::enable("simmesh_enrich_cut")
  }else{
    shinyjs::disable("simmeshby_enrich")
    shinyjs::disable("simmeshmet_enrich")
    shinyjs::disable("simmesh_enrich_cut")
  }
})

observeEvent(input$textArea_enrich,{
  if (gsub(pattern = "\\s",replacement = "",x = input$textArea_enrich,perl = T)!="") {
    dat_enrich$input_1 <- read.table(text=input$textArea_enrich,header = F,fill = T,stringsAsFactors = F)
    dat_enrich$field_enrich <- 1
  }
},ignoreInit = TRUE)

observeEvent(input$fileInput_enrich,{
  inFile <- input$fileInput_enrich
  header <- switch(input$fileheader_enrich,"Yes"=TRUE,"No"=FALSE)
  sep <- switch(input$filesep_enrich,"Tab"="\t","Comma"=";")
  dat_enrich$input_2 <- read.table(inFile$datapath, header = header,sep=sep,stringsAsFactors = F,fill = T,quote = "")
  updateSelectInput(session, "field_enrich", choices = colnames(dat_enrich$input_2))
}, ignoreInit = TRUE)


observeEvent(input$fileInput_enrich2,{
  inFile <- input$fileInput_enrich2
  header <- switch(input$fileheader_enrich2,"Yes"=TRUE,"No"=FALSE)
  sep <- switch(input$filesep_enrich2,"Tab"="\t","Comma"=";")
  dat_enrich$universe <- read.table(inFile$datapath, header = header,sep=sep,stringsAsFactors = F,fill = T,quote = "")
  updateSelectInput(session, "field_enrich2", choices = colnames(dat_enrich$universe))
}, ignoreInit = TRUE)


observeEvent(input$field_enrich,{
  dat_enrich$field_enrich <- input$field_enrich
})

observeEvent(input$field_enrich2,{
  dat_enrich$field_enrich2 <- input$field_enrich2
})



observeEvent(input$submit_enrich,{
  withBusyIndicatorServer("submit_enrich",{
    
    dat_enrich$idtype_enrich <- input$idtype_enrich
    dat_enrich$species_enrich <- input$species_enrich
    
    res_enrich <- reactiveValues()
    plotList_enrich <- reactiveValues()
    if (input$input_id=="text") {
      dat_enrich$input <- dat_enrich$input_1
    }else{
      dat_enrich$input <- dat_enrich$input_2
    }
    if (input$use_id_input_enrich==TRUE) {
      dat_enrich$input <- dat_id$input
      dat_enrich$field_enrich <- dat_id$field_id
      dat_enrich$idtype_enrich <- input$from_id
      dat_enrich$species_enrich <- input$species_id
    }
    
    species_enrich <- switch(dat_enrich$species_enrich,"Human"="human","Mouse"="mouse")
    orgdb_enrich <- switch(species_enrich,"human"=org.Hs.eg.db,"mouse"=org.Mm.eg.db)
    meshdb_enrich <- switch(species_enrich,"human"=MeSH.Hsa.eg.db,"mouse"=MeSH.Mmu.eg.db)
    keggdb_enrich <- switch(species_enrich,"human"="hsa","mouse"="mmu")
    
    total_n <- 0
    total_n=total_n+length(input$msigdb_enrich)
    if (dat_enrich$idtype_enrich!="ENTREZID"){
      total_n=total_n+1
    }
    if ("MeSH" %in% input$msigdb_enrich) {
      total_n=total_n+length(input$MeSH_enrich)-1
    }
    if (input$simgo_enrich==TRUE) {
      total_n=total_n+length(which(input$msigdb_enrich%in%c("BP","CC","MF")))
    }
    
    
    
    if (!is.null(dat_enrich$input)) {
      withProgress(message = 'Processing', value = 0, {
        if (dat_enrich$idtype_enrich!="ENTREZID") {
          incProgress(1/total_n, message = "Processing ID conversion")
          
          dat_enrich$output<- ID_conversion(ids_0 = dat_enrich$input[[dat_enrich$field_enrich]],
                                            key_type = dat_enrich$idtype_enrich,
                                            out_types = "ENTREZID",
                                            species = species_enrich)
          all_ENTREZID<-keys(orgdb_enrich,keytype = "ENTREZID")
          dat_enrich$geneinput<- str_split(string = dat_enrich$output$ENTREZID,pattern = ";") %>%  
            lapply(function(x){x[which(x%in%all_ENTREZID)]}) %>%
            lapply(function(x){x[1]}) %>% 
            unlist()
        }else{
          dat_enrich$geneinput <- dat_enrich$input[[dat_enrich$field_enrich]]
        }
        
        if (!is.null(dat_enrich$universe)) {
          dat_enrich$universe <- dat_enrich$universe[[dat_enrich$field_enrich2]]
        }
        
        for (geneset_raw_enrich in input$msigdb_enrich) {
          
          geneset_enrich <- sapply(geneset_raw_enrich,switch,
                                   "BP"="bp","CC"="cc","MF"="mf","KEGG"="kegg","Pfam"="pfam","Reactome"="reactome","Chromosomes"="chr","Protein complex"="proteincomplex","MeSH"="meshall")
          
          if (geneset_enrich !="meshall" &geneset_enrich !="chr") {
            incProgress(1/total_n, message = paste("Processing",geneset_raw_enrich,"enrichment..."))
            geneset_enrich2gene <- get(paste0(species_enrich,"_",geneset_enrich,"2gene"))
            geneset_enrich2name <- get(paste0(species_enrich,"_",geneset_enrich,"2name"))
            res<- enricher(gene = dat_enrich$geneinput,
                           pAdjustMethod = input$padmethod_enrich,pvalueCutoff = 1,qvalueCutoff = 1,
                           universe =  dat_enrich$universe,
                           minGSSize = input$GSSize_enrich[1],
                           maxGSSize = input$GSSize_enrich[2],
                           TERM2GENE = geneset_enrich2gene,TERM2NAME = geneset_enrich2name)
            res@result$GeneSets <- geneset_raw_enrich
            res_enrich[[geneset_raw_enrich]]<- res
            
          }
          if (geneset_enrich =="meshall") {
            meshdata <- get(paste0(species_enrich,"_meshall"))
            meshdata <- meshdata[which(meshdata$MESHCATEGORY %in% str_sub(string = input$MeSH_enrich,start = 1,end = 1)),]
            for (meshcat in str_sub(string = input$MeSH_enrich,start = 1,end = 1)) {
              incProgress(1/total_n, message = paste0("Processing ",geneset_raw_enrich,"_",meshcat," enrichment..."))
              geneset_enrich2gene <- meshdata[which(meshdata$MESHCATEGORY==meshcat),c(1,2)]
              geneset_enrich2name <- meshdata[which(meshdata$MESHCATEGORY==meshcat),c(1,4)]
              res<- enricher(gene = dat_enrich$geneinput,
                             pAdjustMethod = input$padmethod_enrich,pvalueCutoff = 1,qvalueCutoff = 1,
                             universe =  dat_enrich$universe,
                             minGSSize = input$GSSize_enrich[1],
                             maxGSSize = input$GSSize_enrich[2],
                             TERM2GENE = geneset_enrich2gene,TERM2NAME = geneset_enrich2name)
              res@result$GeneSets <- paste0(geneset_raw_enrich,"_",meshcat)
              res_enrich[[paste0(geneset_raw_enrich,"_",meshcat)]]<- res
              
            }
          }
          if (geneset_enrich =="chr") {
            incProgress(1/total_n, message = paste("Processing",geneset_raw_enrich,"enrichment..."))
            geneset_enrich2gene <- get(paste0(species_enrich,"_",geneset_enrich,"2gene"))
            geneset_enrich2name <- get(paste0(species_enrich,"_",geneset_enrich,"2name"))
            res<- enricher(gene = dat_enrich$geneinput,
                           pAdjustMethod = input$padmethod_enrich,pvalueCutoff = 1,qvalueCutoff = 1,
                           universe =  dat_enrich$universe,
                           minGSSize = 1,
                           maxGSSize = Inf,
                           TERM2GENE = geneset_enrich2gene,TERM2NAME = geneset_enrich2name)
            res@result$GeneSets <- geneset_raw_enrich
            res_enrich[[geneset_raw_enrich]]<- res
            
          }
          
        }
        
        nam_str <- names(isolate(reactiveValuesToList(res_enrich)))
        for (n in nam_str) {
          
          if (input$readable_enrich==TRUE) {
            res_enrich[[n]] <- setReadable(res_enrich[[n]],orgdb_enrich,keyType = "ENTREZID")
          }
          if (input$simgo_enrich==TRUE & n %in% c("BP","CC","MF")) {
            incProgress(1/total_n, message = paste("Processing",n,"simplification..."))
            
            sim <- res_enrich[[n]]
            if (input$simgo_enrich_cut=="p<0.05") {
              sim@result<-res_enrich[[n]]@result[res_enrich[[n]]@result$pvalue<0.05,]
            }
            if (input$simgo_enrich_cut=="p.adjust<0.05") {
              sim@result<-res_enrich[[n]]@result[res_enrich[[n]]@result$p.adjust<0.05,]
            }
            sim@ontology <- n
            sim <- clusterProfiler::simplify(sim,by = input$simgoby_enrich, measure =input$simgomet_enrich, semData = godata(orgdb_enrich, ont=n))
            sim@result$GeneSets <- paste0("sim_",n)
            res_enrich[[paste0("sim_",n)]] <- sim
          }
          
        }
        
        nam_str <- names(isolate(reactiveValuesToList(res_enrich)))
        order_nam <- c("sim_BP","sim_CC","sim_MF","BP","CC","MF","KEGG","Pfam","Reactome","Chromosomes","Protein complex","MeSH")
        nam_str <- nam_str[order(match(nam_str, order_nam))]
        
        
        for (n in nam_str) {
          rownames(res_enrich[[n]]@result) <- 1:nrow(res_enrich[[n]]@result)
          # res_enrich[[n]]@result$pvalue <- formatC(res_enrich[[n]]@result$pvalue, format = "e", digits = 2)
          # res_enrich[[n]]@result$p.adjust <- formatC(res_enrich[[n]]@result$p.adjust, format = "e", digits = 2)
          # res_enrich[[n]]@result$qvalue <- formatC(res_enrich[[n]]@result$qvalue, format = "e", digits = 2)
          res_enrich[[n]]@result$pvalue <- signif(res_enrich[[n]]@result$pvalue, digits = 2)
          res_enrich[[n]]@result$p.adjust <- signif(res_enrich[[n]]@result$p.adjust, digits = 2)
          res_enrich[[n]]@result$qvalue <- signif(res_enrich[[n]]@result$qvalue, digits = 2)
          res_enrich[[n]]@result$`GeneRatio/BackgroundRatio` <- mapply(res_enrich[[n]]@result$GeneRatio,
                                                                       res_enrich[[n]]@result$BgRatio,
                                                                       FUN = function(x,y){
                                                                         sp<- str_split(string = x,pattern = "/")[[1]]
                                                                         GeneRatio<- as.numeric(sp[1])/as.numeric(sp[2])
                                                                         sp<- str_split(string = y,pattern = "/")[[1]]
                                                                         BgRatio<- as.numeric(sp[1])/as.numeric(sp[2])
                                                                         enrichratio <- GeneRatio/BgRatio
                                                                       })
          res_enrich[[n]]@result$`GeneRatio/BackgroundRatio`  <- signif(res_enrich[[n]]@result$`GeneRatio/BackgroundRatio` , digits = 2)
          res_enrich[[n]]@result <- res_enrich[[n]]@result[,c("ID","Description","GeneRatio","BgRatio","GeneRatio/BackgroundRatio","pvalue","p.adjust","geneID","Count","GeneSets")]
          
          plotList_enrich[[n]] <-
            enrichplot::dotplot(res_enrich[[n]],  x = "GeneRatio",split="GeneSets",color = "p.adjust",orderBy = "GeneRatio",
                                showCategory = 12,font.size = 14) + 
            gradient_color("ucscgb")+
            geom_segment(aes(xend = 0, yend = Description),size = 1.6,lineend="butt")+
            geom_point(shape=21,color="white")+
            facet_grid(GeneSets~., scale="free")+
            theme(aspect.ratio = 1,
                  panel.background = element_rect(fill = "#1e406a"),
                  strip.text.y = element_text(size = 12,face = "bold", colour = "#1e406a", angle = 270),
                  strip.background =element_rect(fill="white"))
          
          #scale_y_discrete(labels=function(x) str_wrap(x, width=65))+
          
          
        }
        
        ##### dynamic render UI #####
        output$tabs_enrich <- renderUI({
          tabs_enrich <- lapply( names(isolate(reactiveValuesToList(res_enrich))) , function(n){
            tabPanel(title = n,
                     br(),
                     dataTableOutput(outputId = paste0("res_enrich",n)),
                     hr(),
                     gradientBox(title = tagList(shiny::icon("images"), "Plot output"),width = 12,
                                 footer = fluidRow(
                                   plotOutput(paste0("plot_enrich",n))
                                 )
                     )
            )
          })
          do.call(tabsetPanel,tabs_enrich)
          boxPlus(title = tagList(shiny::icon("table"), "Plot setting and downloads"),width = 12,closable = F,
                  fluidRow(
                    column(6,
                           selectInput('plotby_enrich', 'Plot by:', choices = c("GeneRatio","GeneRatio/BackgroundRatio","Counts","pvalue","p.adjust"), selectize=TRUE,selected="GeneRatio"),
                           prettyCheckbox(inputId = "selectplot_enrich",label = "Whether to plot the row selected",value = T,
                                          icon = icon("check"),status = "default", shape = "curve", animation = "smooth")
                    ),
                    column(6,
                           withBusyIndicatorUI(
                             actionButton("replot_enrich", "Submit",class = "btn-primary",icon = icon("play"))
                           )
                           
                    )))
        })
        
        
        ##### dynamic render output #####
        lapply(names(isolate(reactiveValuesToList(res_enrich))), function(n) {
          DTId_enrich <- paste0("res_enrich",n)
          output[[DTId_enrich]] <- renderDataTable(
            expr = res_enrich[[n]]@result,
            filter = list(position = 'top', clear = FALSE),
            callback = JS('table.page(5).draw(false);'),
            style = 'bootstrap',
            extensions = c('RowReorder','ColReorder',"FixedHeader"),
            options = list(
              #dom = 'Bfrtip',
              colReorder = TRUE,
              rowReorder = TRUE,
              fixedHeader = TRUE,
              searchHighlight = TRUE,
              #pageLength = 10,
              autoWidth = T,
              scrollX='400px',
              lengthChange = TRUE,
              initComplete = JS(
                "function(settings, json) {",
                "$(this.api().table().header()).css({'font-size': '90%'});",
                "$(this.api().table().body()).css({'font-size': '90%'});",
                "}"),
              rowCallback = JS("function(r,d) {$(r).attr('height', '50px')}"),
              columnDefs = list(
                list(targets = c(2),width = '200px',
                     render = JS(
                       "function(data, type, row, meta) {",
                       "return type === 'display' && data.length > 46 ?",
                       "'<span title=\"' + data + '\">' + data.substr(0, 46) + '...</span>' : data;",
                       "}")),
                list(targets = c(1,3:10),
                     render = JS(
                       "function(data, type, row, meta) {",
                       "return type === 'display' && data.length > 20 ?",
                       "'<span title=\"' + data + '\">' + data.substr(0, 20) + '...</span>' : data;",
                       "}"))
              )
            )
          )
          plot_enrich <- paste0("plot_enrich",n)
          output[[plot_enrich]] <-renderPlot(plotList_enrich[[n]],height = 300)
        })
      })
    }
  })
})
# 
# observeEvent(input$replot_enrich,ignoreInit = TRUE,{
#   res_plot_enrich <- reactiveValues()
#   lapply(names(isolate(reactiveValuesToList(res_enrich))), function(n) {
#     res_plot_enrich[[n]]<- res_enrich[[n]]
#     DTId_enrich <- paste0("res_enrich",n)
#     row_enrich_select <- paste0(DTId_enrich,'_rows_selected')
#     if (input$selectplot_enrich==TRUE) {
#       res_plot_enrich[[n]]@result <-  res_enrich[[n]]@result[input[[row_enrich_select]],]
#     }
#     plotList_enrich[[n]] <-
#       enrichplot::dotplot(res_plot_enrich[[n]],  x = input$plotby_enrich ,split="GeneSets",color = "p.adjust",showCategory = 12,font.size = 14) + 
#       gradient_color("ucscgb")+
#       geom_segment(aes(xend = 0, yend = Description),size = 1.6,lineend="butt")+
#       geom_point(shape=21,color="white")+
#       facet_grid(GeneSets~., scale="free")+
#       theme(aspect.ratio = 1,
#             panel.background = element_rect(fill = "#1e406a"),
#             strip.text.y = element_text(size = 12,face = "bold", colour = "#1e406a", angle = 270),
#             strip.background =element_rect(fill="white"))
#     
#     plot_enrich <- paste0("plot_enrich",n)
#     output[[plot_enrich]] <-renderPlot(plotList_enrich[[n]],height = 300)
#   })
# })





# output$plot_enrich <- renderPlot({
#   ggarrange(plotlist=plotList_enrich,align = "hv")
# })
