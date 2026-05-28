$content = Get-Content "E:\情侣网页\index.html" -Raw

# 1. 给 CONFIG 加新字段
$old1 = 'mapZoom: 5,'
$new1 = 'mapZoom: 5,
            galleryMode: "photos",   // "photos" 手动 | "qq_album" 嵌入QQ相册
            qqAlbumUrl: "",          // QQ相册分享链接'
$content = $content.Replace($old1, $new1)

# 2. 更新相册渲染函数
$old2 = 'function renderGallery() {'

$new2 = @'
function renderGallery() {
            const grid = document.getElementById("galleryGrid");

            // QQ相册iframe模式
            if (CONFIG.galleryMode === "qq_album" && CONFIG.qqAlbumUrl) {
                grid.style.display = "none";
                const oldIframe = document.getElementById("qqAlbumFrame");
                if (oldIframe) oldIframe.remove();
                const oldWrapper = document.getElementById("qqAlbumWrapper");
                if (oldWrapper) oldWrapper.remove();
                const wrapper = document.createElement("div");
                wrapper.id = "qqAlbumWrapper";
                wrapper.style.cssText = "max-width:1000px;margin:0 auto;border-radius:16px;overflow:hidden;border:1px solid rgba(255,105,180,0.2);height:600px";
                wrapper.innerHTML = "<iframe id=\"qqAlbumFrame\" src=\"" + CONFIG.qqAlbumUrl + "\" style=\"width:100%;height:100%;border:none\" allowfullscreen></iframe>";
                grid.parentNode.insertBefore(wrapper, grid.nextSibling);
                return;
            }

            // 默认照片模式
            grid.style.display = "";
            const oldW = document.getElementById("qqAlbumWrapper");
            if (oldW) oldW.remove();
            grid.innerHTML = "";

            if (CONFIG.photos.length === 0) {
                for (let i = 1; i <= 6; i++) {
                    grid.innerHTML += "<div class=\"gallery-item\"><div class=\"placeholder\"><div class=\"icon\">📷</div><div class=\"text\">合照 " + i + "</div></div></div>";
                }
                return;
            }

            CONFIG.photos.forEach(function(photo, index) {
                grid.innerHTML += "<div class=\"gallery-item\" onclick=\"openLightbox(" + index + ")\"><img src=\"" + photo.src + "\" alt=\"" + (photo.title || "合照") + "\" loading=\"lazy\" onerror=\"this.parentElement.innerHTML=''<div class=placeholder><div class=icon>💔</div><div class=text>加载失败</div></div>''\"></div>";
            });
        }
'@

# 找到旧函数的结束位置，从 function renderGallery() { 到下一个函数前的 }
$idxStart = $content.IndexOf('function renderGallery() {')
$idxEnd = $content.IndexOf('function openLightbox(', $idxStart)
$before = $content.Substring(0, $idxStart)
$after = $content.Substring($idxEnd)
$content = $before + $new2.Trim() + "
        " + $after

# 修复 onerror 中的双单引号
$content = $content.Replace("''<div class=placeholder>", "'<div class=placeholder>").Replace("加载失败</div></div>''", "加载失败</div></div>'")

$content | Set-Content "E:\情侣网页\index.html" -Encoding UTF8 -NoNewline
Write-Host "index.html 更新完成"
