/**
 * Created by Administrator on 2018/6/14.
 */


'use strict';

;+function (Vue) {

    Vue.filter("hideMobile", function (value, hasJoin) {
        if(value && typeof hasJoin !== 'undefined'){
            if(!hasJoin){
                return value.replace(/\d{3}(\d{4})/, function ($1,$2) {
                    return $1.replace($2, '****')
                })
            }
        }
        return value;
    })
    // Vue.filter('textLineFeedFilter', function (value) {
    //     if(!value) return '';
    //     return value
    // })
    Vue.filter("getRoomNames", function (value, entries, key, roomName) {
        var names = [];
        var parent = entries[value];
        key = key || 'pId';
        while (parent) {
            if (parent[key] === '1') {
                names.unshift(parent.name);
                break;
            }
            names.unshift(parent.name);
            parent = entries[parent[key]];
        }
        if(roomName){
            names.push(roomName)
        }
        names = names.slice(1);
        return names.join('/');
    })
    
    Vue.filter('userCountryName', function (value, cityIdKeyData) {
        if (!value) {
            return '';
        }
        if (cityIdKeyData[value]) {
            return cityIdKeyData[value].shortName
        }
        return value
    });

    //用户详情页地址跳转
    Vue.filter('goToUserPage', function (value) {
        var userType = value.user_type || value.userType;
        if(userType === '1') return '/f/sys/frontStudentExpansion/form?id='+ (value.st_id || value.id);
        return '/f/sys/frontTeacherExpansion/view?id='+(value.te_id || value.id);
    })

    //单个profession查找上级
    Vue.filter('getProfessionName', function (value, entries) {
        if(!value || !entries) return '';
        var profession = entries[value];
        var office = entries[profession.parentId];
        var text = '';
        if(office){
            text += office.name + '/';
        }
        text += profession.name;
        return text;
    })

    //用户导师详情
    Vue.filter('userRoleName', function (value, userId) {
        if(!value) return '';
        if (userId === value.leaderId) {
            return '项目负责人'
        } else {
            if (value.userType === '1') {
                return '组成员'
            }
        }
        return '导师'
    })

    //用户导师详情 时间周期
    Vue.filter('userProContestDRange', function (value) {
        var startDate, endDate;
        if(!value) return '';
        if (value.startDate) {
            startDate = moment(value.startDate).format('YYYY-MM-DD');
        }
        if (value.endDate) {
            endDate = moment(value.endDate).format('YYYY-MM-DD');
        }
        if (startDate) {
            return startDate + '至' + endDate;
        }
        return ''
    })

    Vue.filter('textEllipsis', function (value, size) {
        if(!value) return '';
        size = size || 30;
        value = value.toString();
        if(value.length <= size){
            return value;
        }
        return value.substring(0, size - 2) + '...';
    })

    //默认项目大赛图片
    Vue.filter('defaultProPic', function (value) {
        if(!value) return '/img/video-default.jpg';
        return value;
    })


    Vue.filter('ftpHttpFilter', function (value, ftpHttp) {
        if (!value) return '';
        return ftpHttp + value.replace('/tool', '')
    })

    Vue.filter('studentPicFilter', function (value) {
        if (!value) return '/img/u4110.png';
        return value;
    })

    Vue.filter('proGConLogo', function (value) {
        if (!value) return '';
        return value.url;
    })

    Vue.filter('proGConPicFilter', function (value) {
        if (!value) return '/images/default-pic.png';
        return value;
    })

    Vue.filter('selectedFilter', function (value, entries) {
        if(typeof value === 'undefined' || !entries){ return '-' };
        return entries[value];
    });

    Vue.filter('collegeFilter', function (value, entries) {
            if(!value){ return '' };
            if(!entries[value]){
                return ''
            }
            return entries[value].name;
        });
    
    Vue.filter('cascaderCollegeFilter', function (value, entries) {
        var names = [], len;
        if(!value) return '';
        if (value.length < 1){
            return '';
        }
        len = value.length;
        if(entries[value[len - 1]]){
            names.push(entries[value[len - 1]].name)
        }
        if(names.length > 0 && len - 2 > - 1){
            names.unshift(entries[value[len - 2]].name)
        }

        return names.join('/')
    })

    Vue.filter('checkboxFilter', function (value, entries) {
        var arr = [];
        if (!value || value.length < 1 || !entries){
            return '';
        }
        if({}.toString.call(value) !== '[object Array]'){
            value = value.split(',')
        }
        value.forEach(function (item) {
            arr.push(entries[item]);
        })
        return arr.join('；')
    })
    
    Vue.filter('filterPwRoomAddress', function (value, entries) {
        var parentId = value.parentId || value.pId;
        var address = [value.name];
        while (parentId){
            var parent = entries[parentId];
            if(!parent) break;
            address.unshift(parent.name);
            parentId = parent.parentId || parent.pId ;
            if(value.floorNum){
                address.push(value.floorNum + '层');
            }
        }
        return address.join('-');
    })

    Vue.filter('filterPwEnterType', function (value, entries) {
        var types = ['eteam', 'eproject', 'ecompany'];
        var i = 0;
        var enterTypes = [];
        while (i < types.length){
            if(value[types[i]]){
                enterTypes.push(entries[value[types[i]].type]);
            }
            i++;
        }
        return enterTypes.join('-')
    })

    Vue.filter('formatDateFilter', function (value, pattern) {
        if (!value) return '-';
        return moment(value).format(pattern)
    })

    Vue.filter('fileSuffixFilter', function (ext) {
       var extname;
       switch (ext) {
           case "xls":
           case "xlsx":
               extname = "excel";
               break;
           case "doc":
           case "docx":
               extname = "word";
               break;
           case "ppt":
           case "pptx":
               extname = "ppt";
               break;
           case "jpg":
           case "jpeg":
           case "gif":
           case "png":
           case "bmp":
               extname = "image";
               break;
           case 'txt':
               extname = 'txt';
               break;
           case 'zip':
               extname = 'zip';
               break;
           case 'rar':
               extname = 'rar';
               break;
           default:
               extname = "unknow";
       }
       return '/img/filetype/'+extname+'.png'
   })

}(Vue);