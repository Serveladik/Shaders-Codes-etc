Shader "Test/DisolveShader"
{
    
    Properties
    {
        _MainTex1      ("Main Texture1", 2D)    = "white" {}
        //_MaskTex ("Mask Texture", 2D) = "white"{}
        _DissolveTexture("Disolve Texture",2D)   = "black" {}
        _EmTex    ("Emission Texture",2D)       = "black" {}
        _Color ("Emission color",     Color)    = (1,1,1,1) 
       
        _DissolveAmount("Dissolve amount",Range (0,1))   = 0
        _BordersAmount("Borders size",Range (0,1))   = 0
        _DissolveColor ("Dissolve color",     Color)    = (1,1,1,1) 

        
        
        

        _LightIntensity("Intensity",float)      = 1
        _EmissionRange ("Range",Range(0,1))     = 0
        
        _NormalMap     ("Normal Map", 2D)       = "bump" {}
        _NormalRange ("Normal Intensity",Range(0,1))     = 0
    }
    SubShader
    {
        CGPROGRAM
        #pragma target 3.0
        #pragma surface surf Lambert

        sampler2D _MainTex1,_EmTex,_NormalMap,_DissolveTexture;
        //sampler2D _MaskTex;
        fixed _DissolveAmount,_BordersAmount;
        struct Input
        {
           fixed2 uv_MainTex1,uv_MainTex2,uv_MainTex3;
           //fixed2 uv_MaskTex;
        };

        fixed3 _Color;
        fixed3 _DissolveColor;
        fixed _EmissionRange;
        fixed _NormalRange;
        float _LightIntensity;
        void surf(Input input,inout SurfaceOutput output)
        {
            //fixed3 mask = tex2D(_MaskTex, input.uv_MaskTex);
            fixed3 color = tex2D(_MainTex1, input.uv_MainTex1);
            float3 dissolve_value = tex2D(_DissolveTexture, input.uv_MainTex1).r;
            clip(dissolve_value - _DissolveAmount);

            fixed3 emTex = tex2D(_EmTex,input.uv_MainTex1);
            half fadeMask = emTex;
            fadeMask = smoothstep(_EmissionRange*1.1,_EmissionRange*1.4,fadeMask);

            
            output.Albedo = color;
            output.Emission = fadeMask * _Color * _LightIntensity;
            output.Emission += _DissolveColor * step(dissolve_value - _DissolveAmount+0.01,_BordersAmount)*_LightIntensity;
            
            output.Normal = UnpackNormal(tex2D(_NormalMap,input.uv_MainTex1)*_NormalRange);
        }
        
        ENDCG
        
    }
}

